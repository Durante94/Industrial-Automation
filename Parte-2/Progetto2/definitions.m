function [costs,machines,jobs] = definitions(fileName)
    [costs]=xlsread(fileName);

    dim=size(costs);

    machines=dim(1);
    jobs=dim(2);
end

