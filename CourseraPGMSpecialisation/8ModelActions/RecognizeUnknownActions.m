% You should put all your code for recognizing unknown actions in this file.
% Describe the method you used in YourMethod.txt.
% Don't forget to call SavePrediction() at the end with your predicted labels to save them for submission, then submit using submit.m

function [predicted_labels] = RecognizeUnknownActions(datasetTrain, datasetTest, G, maxIter)
Ps = {};
loglikelihood = {};
ClassProbs = {};
PairProbs = {};

for action=1:length(datasetTrain)
  theN=size(datasetTrain(action).poseData,1);
  theK=size(datasetTrain(action).InitialClassProb,2);
  clear poseData2D;
  clear initialCP;
  clear covmat;
  clear newposeData2D;
  for i=1:theN
      poseData2D(i,1:10)=datasetTrain(action).poseData(i,1:10,1);
      poseData2D(i,11:20)=datasetTrain(action).poseData(i,1:10,2);
      poseData2D(i,21:30)=datasetTrain(action).poseData(i,1:10,3);
  end
  newposeData2D=poseData2D;
  for i=1:30
      newposeData2D(:,i)=(poseData2D(:,i)-min(poseData2D(:,i)))/(max(poseData2D(:,i))-min(poseData2D(:,i)));
  end
  [idx,dummycenters]=kmeans(newposeData2D,theK);
  for i=1:theK
      indx2=find(idx==i);
      nowposes=newposeData2D(indx2,:);
      covmat{i}=cov(nowposes)+.0001 * eye(30);
      centers(i,1:30)=mean(nowposes);
  end
  for i=1:theN
      for j=1:theK
          initialCP(i,j)=mvnpdf(newposeData2D(i,:),centers(j,:),covmat{j});
      end
  end
  for i=1:theN
      initialCP(i,:)=initialCP(i,:)/sum(initialCP(i,:));
  end
  
  initialPP=datasetTrain(action).InitialPairProb;
  for i=1:length(datasetTrain(action).actionData)
      for kk=1:length(datasetTrain(action).actionData(i).pair_ind)
          targ=datasetTrain(action).actionData(i).marg_ind(kk);
          littleprob=zeros(theK,theK);
          for j1=1:theK
              for j2=1:theK
                  littleprob(j1,j2)=initialCP(targ,j1)*initialCP(targ+1,j2);
              end
          end
          littp=reshape(littleprob,1,theK*theK);
          littp=littp/sum(littp);
          initialPP(datasetTrain(action).actionData(i).pair_ind(kk),:)=littp;
      end
  end
  %[pa ll cc pp] = EM_HMM(datasetTrain(action).actionData, datasetTrain(action).poseData, G, datasetTrain(action).InitialClassProb, datasetTrain(action).InitialPairProb, maxIter);
  [pa ll cc pp] = EM_HMM(datasetTrain(action).actionData, datasetTrain(action).poseData, G, initialCP, initialPP, maxIter);
  Ps{action} = pa;
  loglikelihood{action} = ll;
  ClassProb{action} = cc;
  PairProb{action} = pp;
end

for testcase=1:length(datasetTest.actionData)
  
  testll = zeros(1, length(datasetTest));
  
  for action = 1:length(datasetTrain)
  
    poseData = datasetTest.poseData(datasetTest.actionData(testcase).marg_ind, :, :);
    P = Ps{action};
    actionData = datasetTest.actionData(testcase);
    
  
    N = length(actionData.marg_ind);
    K = size(ClassProb{action}, 2);
    numparts = size(datasetTest.poseData, 2);
  
    logEmissionProb = zeros(N, K);

    for example=1:N
      for k=1:K
      
        logEmissionProb(example, k) = 0;
      
        for part=1:numparts
        
          parentpart = 0;
          parentals = [];

          if G(part, 1) == 1
            parentpart = G(part, 2);
            parent_y = poseData(example, parentpart, 1);
            parent_x = poseData(example, parentpart, 2);
            parent_alpha = poseData(example, parentpart, 3);
            parentals = [ parent_y parent_x parent_alpha ];
          end
        
          if (parentpart == 0)
            pdf_y = lognormpdf(poseData(example, part, 1), P.clg(part).mu_y(k), P.clg(part).sigma_y(k));
            pdf_x = lognormpdf(poseData(example, part, 2), P.clg(part).mu_x(k), P.clg(part).sigma_x(k));
            pdf_angle = lognormpdf(poseData(example, part, 3), P.clg(part).mu_angle(k), P.clg(part).sigma_angle(k));

            logEmissionProb(example, k) = sum( [ logEmissionProb(example, k) pdf_y pdf_x pdf_angle ] );
          else
            mu = P.clg(part).theta(k, 1) + parentals * P.clg(part).theta(k, 2:4)';
            sigma = P.clg(part).sigma_y(k);
            pdf_y = lognormpdf(poseData(example, part, 1), mu, sigma);
          
            mu = P.clg(part).theta(k, 5) + parentals * P.clg(part).theta(k, 6:8)';
            sigma = P.clg(part).sigma_x(k);
            pdf_x = lognormpdf(poseData(example, part, 2), mu, sigma);
          
            mu = P.clg(part).theta(k, 9) + parentals * P.clg(part).theta(k, 10:12)';
            sigma = P.clg(part).sigma_angle(k);
            pdf_angle = lognormpdf(poseData(example, part, 3), mu, sigma);
          
            logEmissionProb(example, k) = sum( [ logEmissionProb(example, k) pdf_y pdf_x pdf_angle ] );
          end

        end
      end
    end

    factorList = repmat(struct ('var', [], 'card', [], 'val', []), 1, 2 * N );
    currentF = 1;
    
    % P(S_1)
    % factorList(currentF).var = [ actionData(action).marg_ind(1) ];
    factorList(currentF).var = 1;
    factorList(currentF).card = [ K ];
    factorList(currentF).val = log(P.c);
    assert(all(size(factorList(currentF).val) == [ 1 prod(factorList(currentF).card) ]));
    currentF = currentF + 1;
    
    % P(S_i | S_i-1)
    
    for i=2:N
      this = actionData.marg_ind(i);
      prev = actionData.marg_ind(i-1);
      % factorList(currentF).var = [ prev this ];
      factorList(currentF).var = [i-1 i];
      factorList(currentF).card = [ K K ];
      factorList(currentF).val = log(P.transMatrix(:)');
      assert(all(size(factorList(currentF).val) == [ 1 prod(factorList(currentF).card) ]));
      currentF = currentF + 1;
    end

    for i = 1:N
      factorList(currentF).var = [i];
      factorList(currentF).card = [K];
      factorList(currentF).val = logEmissionProb(i, :);
      assert(all(size(factorList(currentF).val) == [ 1 prod(factorList(currentF).card) ]));
      currentF = currentF + 1;
    end
    
    [Marginals PCalibrated] = ComputeExactMarginalsHMM(factorList);
  
    testll(action) = logsumexp(PCalibrated.cliqueList(end).val);
    
  end
  
  [ dummy predicted_labels(testcase) ] = max(testll);
  
end

predicted_labels = predicted_labels';
SavePredictions(predicted_labels);
end