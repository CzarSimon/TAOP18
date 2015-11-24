function F = plotProgress(objValue,STYLE)
%
% Plot function used to illustrate the solution progress
%
% plotProgress(objValue,STYLE)
%
% Input arguments:
%
%  objValue  - Vector with objective values
%
%  STYLE     - 1  Standard plot
%              2  Stairs plot (default)
%              3  Plot each value as a point

if nargin < 2
   STYLE = 2;
end

N  = length(objValue);

best = zeros(1,N);

best(1) = objValue(1);
for k = 2:N
   best(k) = min(best(k-1),objValue(k));
end

F = figure(); hold on; box on;

switch STYLE
   case 1
      plot(1:N,objValue,'k');
      plot(1:N,best,'r');
      
   case 2
      stairs(1:N,objValue,'k');
      stairs(1:N,best,'r', 'LineWidth',2);
      
   otherwise
      plot(1:N,objValue,'k.','MarkerSize',14);
      stairs(1:N,best,'r');
end
      

title('Objective value progress', 'FontSize',14, 'FontWeight','Bold')
xlabel('Iterations', 'FontSize',14, 'FontWeight','Bold')
ylabel('Objective value', 'FontSize',14, 'FontWeight','Bold')

minValue = min(objValue);
maxValue = max(objValue);

ylim([minValue-5,maxValue+5])

end

