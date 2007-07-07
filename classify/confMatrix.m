% Generates a confusion matrix according to true and predicted data labels.
%
% CM(i,j) denotes the number of elements of class i that were given label
% j.  In other words, each row i contains the predictions for elements whos
% actual class was i.  If IDXpred is perfect, then CM is a diagonal matrix
% with CM(i,i) equal to the number of instances of class i.
%
% To normalize CM to [0,1], divide each row by sum of that row:
%  CMnorm = CM ./ repmat( sum(CM,2), [1 size(CM,2)] );
%
% USAGE
%  CM = confmatrix( IDXtrue, IDXpred, ntypes )
%
% INPUTS
%  IDXtrue     - [nx1] array of true labels [int values in 1-ntypes]
%  IDXpred     - [nx1] array of predicted labels [int values in 1-ntypes]
%  ntypes      - maximum number of types (should be > max(IDX))
%
% OUTPUTS
%  CM          - ntypes x ntypes confusion array with integer values
%
% EXAMPLE
%  IDXtrue = [ones(1,25) ones(1,25)*2];
%  IDXpred = [ones(1,10) randint(1,30,[1 2]) ones(1,10)*2];
%  CM = confmatrix( IDXtrue, IDXpred, 2 )
%  confmatrix_show( CM, {'class-A','class-B'}, {'FontSize',20} )
%
% See also CONFMATRIX_SHOW

% Piotr's Image&Video Toolbox      Version 1.5
% Written and maintained by Piotr Dollar    pdollar-at-cs.ucsd.edu
% Please email me if you find bugs, or have suggestions or questions!

function CM = confmatrix( IDXtrue, IDXpred, ntypes )

IDXtrue=IDXtrue(:); IDXpred=IDXpred(:);

%%% convert common binary labels [-1/+1] or [0/1] to [1/2]
if( ntypes==2 )
  IDX = [IDXtrue;IDXpred];
  if( min(IDX)>=-1 && max(IDX)<=1 && all(IDX~=0))
    IDXtrue=IDXtrue+2;  IDXpred=IDXpred+2;
    IDXtrue(IDXtrue==3) = 2;  IDXpred(IDXpred==3) = 2;
  elseif( min(IDX)>=0 && max(IDX)<=1 )
    IDXtrue=IDXtrue+1;  IDXpred=IDXpred+1;
  end
end

%%% error check
[IDXtrue,er] = checknumericargs( IDXtrue, [], 0, 2 ); error(er);
[IDXpred,er] = checknumericargs( IDXpred, [], 0, 2 ); error(er);
if( length(IDXtrue)~=length(IDXpred) )
  error('Lengths of IDXs must match up.'); end
if( max([IDXtrue;IDXpred])>ntypes )
  error(['ntypes = ' int2str(ntypes) ' not large enough']); end

%%% generate CM
CM = zeros(ntypes);
for i=1:ntypes
  vals = IDXpred( IDXtrue==i );
  for j=1:ntypes; CM(i,j) = sum(vals==j); end
end