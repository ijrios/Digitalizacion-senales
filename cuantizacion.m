%===============================================================================
% MUESTREO Y CUANTIZACI�N DE SE�AL ANALOGA 
%===============================================================================
clc;
clear all;
close all;
disp("BIEVENIDOS AL PROGRAMA");
% Solicitud del vector t de tiempo "continuo" para la señal a procesar.
t=-2:0.001:2;
% Solicitud de la funci�n s de la se�al  en terminos de la variable t.
s= 2*cos(2*pi*0.5*t)-cos(2*pi*3.8*t)+ 2*sin(pi*4*t);% Se�al  
inicial=subs(find(t,1));            % Primer valor del vector t. 
final=subs(find(t,1,'last'));       % Ultimo valor del vector t.
% Vector de valores de la señal en el tiempo "continuo" t.
figure(1);
subplot(3,1,1);
plot(t,s);
grid on;
xlabel('[s]');
ylabel('Hz');
title('FORMA DE ONDA ORIGINAL');

fs=input('Ingrese frecuencia de muestreo:');
%periodo de la se�al de muestreo
T=1/fs;
n=t(inicial):T:t(final);
%vector de valores muestreadas
y2= 2*cos(2*pi*0.5*n)-cos(2*pi*3.8*n)+ 2*sin(pi*4*n);
subplot(3,1,2);
stem(n,y2);
grid on;
xlabel('[s]');
ylabel('Hz');
title('SE�AL MUESTRADA');

b = input('Ingrese n�mero de bits para la cantizaci�n: ');
rango=max(s)-min(s); % Rango de la se�al
delta = rango/(2^b);
nivel=zeros(1,2^b);
% Asignaci�n del valor del primer nivel
nivel(1)=min(s)+delta/2;
% Asignaci�n de los valores restantes de nivel.
for i=2:2^b                  
    nivel(i)=nivel(i-1)+delta;
end
% Grafica los niveles de cuantizaci�n.
subplot(3,1,3);
hold on;
for i=1:2^b
    nive=nivel(i);
    plot([t(inicial), t(final)], [nive, nive]);
end
title('NIVELES DE CUANTIZACI�N');
hold off;


N=find(n,1,'last');
% Genera el vector de ceros para asignar la cuantizaci�n de cada muestra
y4=zeros(1,N);
%vector de codificacion
y5=zeros(1,N);
% Asignaci�n de la cuantizaci�n y codificaci�n de las muestras.
for i=1:N  
    for j=1:2^b   
        if y2(i)<=nivel(1)
            y4(i)=nivel(1);
            y5(i)=0;
        elseif abs(y2(i)-nivel(j))<=delta/2
            y4(i)=nivel(j);
            y5(i)=j-1;
        elseif y2(i)>=nivel(j)
            y4(i)=nivel(j);
            y5(i)=j-1;
        end 
    end
end

figure(2)
subplot(3,1,1)
stem(n,y4,'g');
title('CUANTIZACI�N');
subplot(3,1,2)
stairs(n,y4,'m');                   
grid on;
title('DIGITALIZACI�N');
subplot(3,1,3)
y6=interp1(n,y4,t);
plot(t,y6,'b'); 
grid on;
title('PAM CUANTIZADA');

error = s-y6;
acum  = sum(error);
fprintf('el error es : \n %4.4f\n',acum);



