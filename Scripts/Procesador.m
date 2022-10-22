%%
%  PROCESAR
%  Y EXTRAER CARACTERISTICAS
%  DE LAS IMAGENES
%

%% Limpiar el espacio de trabajo
clc; clear all; close all; % limpiar

% write_path = '/MATLAB Drive/Published/Clasificacion';
write_path = '/Clasificacion';

%% eliminar el archivo de salida
kk = 'entrenamiento';
table_file_name = strcat(write_path, '/Descriptores_',kk, '.xlsx');
try
    delete(table_file_name);
catch
    warning('The file dosent exists');
end

%% Leer imagenes de prueba
n = 1;
% read_path = strcat('/MATLAB Drive/Published/ElementosFerreteria/',kk,'/');
read_path = strcat('/ElementosFerreteria/',kk,'/');
files = dir(read_path);
names = {};
for f=3:length(files);
    
    %leyendo imagen
    file_2_read = strcat(files(f).folder,'/',files(f).name);
    titulo = replace(files(f).name,"_"," ");
    imagenRGB = imread(file_2_read);


    % procesando imagen ---------------------------------------------------
    ImgProc = ProcesarImagen(imagenRGB);

    % ver figura
    figure(1), subplot(1,2,1), imshow(imagenRGB), title(titulo) %% una figura nueva por cada imagen
    figure(1), subplot(1,2,2), imshow(ImgProc), title('procesada')     %% una figura nueva por cada imagen
    
    descrip = ExtraeDescriptores(ImgProc);
    descrip.Puntas = NumeroDePuntas(ImgProc);
    
    try
        tabla = [tabla, [descrip]];
    catch
        tabla = [descrip];
    end
    
    file_names{n} = titulo;

     n = n + 1;

end

%% crear tabla
T = struct2table(tabla);
T = [array2table(file_names','VariableNames',{'Archivo'}), T];
T;


%% write table
writetable(T, table_file_name );
table_file_name 

%% funciones

% Numero de puntas
function puntas = NumeroDePuntas(ImgProc);
    % Esqueletización
    BW_esquel = bwmorph(ImgProc,'skel',Inf);
    out2 = bwskel(BW_esquel,'MinBranchLength',150);
    BW_esquel2 = bwmorph(uint8(out2)*255,'endpoints');
    puntas = sum(sum(BW_esquel2)); %Conteo de puntas
end

% limpiar caracteristicas
function descrip = LimpiarDescriptores(descrip);
    cols_2_remove = {'SubarrayIdx','ConvexHull','ConvexImage','Image','FilledImage','Extrema','PixelIdxList','PixelList','MaxFeretCoordinates','MinFeretCoordinates'};
    for c=1:length(cols_2_remove)
        col = cols_2_remove(c);
        try
            descrip = rmfield(descrip, col);
        catch
            disp(strcat('Campo quitado: ', col));
        end
    end
end

% procesando imagen ---------------------------------------------------
function ImgProc = ProcesarImagen(imagenRGB);
    I = rgb2gray(imagenRGB);
    size_imagen = size(imagenRGB);
    Ihistograma = zeros(1,256);
     for j=1:size_imagen(1)
         for k=1:size_imagen(2)
             r = I(j,k);
             Ihistograma(r + 1) = Ihistograma(r + 1) + 1;
         end 
     end 
     [a,b]=size(I);
     y=zeros(a,b);
     for j=1:a
        for k=1:b
            if I(j,k) > 60
                y(j,k)=1;
            else
                y(j,k)=0;
            end
        end
    end

    % Crea un elemento estructurante morfológico plano. -------------------
    % Vamos a crear 4 formas structurales
    % se1 = strel('square', 5);    %Cuadrado de lado 5
    se2 = strel('line', 10, 30); %Linea de  long 10 y ángulo 30
    % se3 = strel('disk', 15);     %Disco de radio 15
    % se4 = strel('ball', 15, 5);  %Circulo/bola de radio 15 y alto 5
    
    % Operaciones morfológicas --------------------------------------------
    A = imopen(y, se2);   %Apertura
    D = imdilate(A, se2); %Dilatación
   
    % Binarización de la imagen y llenado de huecos -----------------------
    thresh = graythresh(D); %%%%Hacerñlo con manual no otsu
    binh = ~imbinarize(D, thresh);
    
    % Llenar huecos, si los hay. Dentro del objeto ------------------------
    ImgProc = imfill(binh, 'holes');
    %figure(i-2), imshow(binh_fill), title('Llenado de huecos')
end


% extrae descriptores
function descrip = ExtraeDescriptores(ImgProc);
    % Etiquetado de la imagen
    [I_label, num] = bwlabel(ImgProc,8);
    
    % Presentación de la imagen con cada objeto enmarcado - BoundingBox
    I_cdes = regionprops(I_label, 'all');%Calcula diferentes características para cada objeto de la imagen
    
    % solo el que tiene mayor area
    areaD = [I_cdes.Area];
    maxA = max(areaD);
    pam = find(areaD==maxA);
    descrip = I_cdes(pam,:);

    descrip = LimpiarDescriptores(descrip);

end