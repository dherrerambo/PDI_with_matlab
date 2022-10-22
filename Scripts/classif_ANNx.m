%% 
% PDI con Redes Neuronales
% 

%% Limpiar el espacio de trabajo
clc; clear all; close all; % limpiar

%% Configuración inicial
% read_path = '/MATLAB Drive/Published/Clasificacion';
read_path = '/Clasificacion';
numero_elementos = 5; %% numero de elementos por categoria
elementos_test = 2; %% numero de elementos del test <= numero_elementos
campos_a_evaluar = ["Area","Circularity", "FilledArea", "Perimeter", "MajorAxisLength", "Puntas"];

hiddenLayerSize = [10 20 10];

%% Leer  parámetros de entrenamiento
fName = strcat(read_path,'/Descriptores_entrenamiento.xlsx');
matr_descrip = readtable(fName);
ss = size(matr_descrip); %tamaño de la matriz, en este caso de 36x6
disp(strcat("Tabla de descriptores, shape=", num2str(ss(:,1)),", ", num2str(ss(:,2))))
 

%% Entrenamiento y Validacion
% campos_a_evaluar = matr_descrip.Properties.VariableNames  % todos los campos
[X_p, Y_p, X_t, Y_t] = CreaPruebaTest(matr_descrip, numero_elementos, elementos_test, campos_a_evaluar);

%% Configuración de la red neuronal
disp('Configuring Neural Network...');
trainFcn = 'trainlm';                              % Levenberg-Marquardt
net = fitnet(hiddenLayerSize,trainFcn);
% net.layers{1}.transferFcn='logsig';                %tansig by default, but I can put another
% net.layers{2}.transferFcn='tansig';   
% net.layers{3}.transferFcn='purelin';  
net.trainParam.goal = 0.01;
net.trainParam.epochs = 1000;
net = init(net);                                  %initializing the network with previous configurations
% view(net)                                          % para visualizar la red final 

%% Resultado ANN
[net, tr] = train(net,X_p',Y_p');               %training

%Respuesta del clasificador
outputs = round(net(X_t'));
outputs % para presentar en pantalla un vector fila con los resultados (como responde)
Y_t' %... y compararlo con el objetivo (como debería responder)

% Evaluación del desempeño: Es mejor si se acerca a 100
%performance = perform(net, target', outputs)
eval = sum(outputs==Y_t')/length(Y_t)*100 

% save ANN_model net % guardar modelo clasificador

%% Funciones
function [X_p, Y_p, X_t, Y_t] = CreaPruebaTest(tabla, n, t, campos)
    
    % n = numero de elementos por categoria
    % t = elementos para test

    ss = size(tabla); %tamaño de la matriz, en este caso de 36x6
    for i = 1:n:ss(1)
        s = strcat("P=", num2str(i), "-", num2str(i+n-t-1), ", T=",num2str(i+n-t), "-", num2str(i+n-1));
        % disp(s)
        temp_P = tabla(i:i+n-t-1,:);
        try
            Prueba = vertcat(Prueba, temp_P);
        catch
            Prueba = temp_P;
        end
        temp_T = tabla(i+n-t:i+n-1,:);
        try
            Test = vertcat(Test, temp_T);
        catch
            Test = temp_T;
        end
        
    end
    disp(strcat("Numero de elementos por Tipo:", num2str(n),", Elementos para Test=", num2str(t)))
    disp(strcat("Distribucion de Prueba=", num2str(size(Prueba,1)), ", Test=", num2str(size(Test,1))))

    % Prueba
    X_p = Prueba(:,campos);
    X_p = table2array(X_p);
    try
        Y_p = Prueba.ElementoID;
    catch
        T = repmat([1 2 3 4 5 6 7 8 9 10],n-t,1);
        Y_p = T(:);
    end
    msg = strcat('Prueba: X=', string(length(X_p)), ', target=', string(length(Y_p)));
    disp(msg);
    
    % Test
    X_t = Test(:,campos);
    X_t = table2array(X_t);
    try
        Y_t = Test.ElementoID;
    catch
        T = repmat([1 2 3 4 5 6 7 8 9 10],t,1);
        Y_t = T(:);
    end
    msg = strcat('Prueba: X=', string(length(X_t)), ', target=', string(length(Y_t)));
    disp(msg);
end