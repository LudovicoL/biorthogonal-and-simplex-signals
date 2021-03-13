% Inizio l'esecuzione eliminando le variabili in memoria e pulendo il terminale:
clear all;
clc;

% Importo le variabili dei segnali Simplex:
load('variables_simplex');

Smplx_Eb_No_dB=New_Eb_No_dB;
Smplx_Pe=Pe;

% Importo le variabili dei segnali Biortogonali:
load('variables_biortogonali');

% Creo un vettore con i possibili colori dei grafici da stampare:
colors1=['k' 'r' 'b' 'g' 'y' 'c' 'm'];

Lungh_M=length(M);                              % Lunghezza del vettore contenente i valori di M.

% Stampo a video due messaggi per avvisare l'utente che la simulazione è cominciata:
fprintf(1,'SEGNALI SIMPLEX VS BIORTOGONALI\n');
fprintf(1,'Simulazione in corso...\n');

% Disegno il grafico dei segnali Simplex a confronto con i segnali Biortogonali:
semilogy(Eb_No_dB,Pe(1,:),'k:');                    % Biortogonale: tratteggiato.
hold;
grid on;
semilogy(Smplx_Eb_No_dB(1,:),Smplx_Pe(1,:),colors1(1));     % Simplex: colorato normalmente.
semilogy(Eb_No_dB,Pe(2,:),'r:');
semilogy(Smplx_Eb_No_dB(2,:),Smplx_Pe(2,:),colors1(2));
semilogy(Eb_No_dB,Pe(3,:),'b:');
semilogy(Smplx_Eb_No_dB(3,:),Smplx_Pe(3,:),colors1(3));
semilogy(Eb_No_dB,Pe(4,:),'g:');
semilogy(Smplx_Eb_No_dB(4,:),Smplx_Pe(4,:),colors1(4));

%{
for Ind_M=2:Lungh_M
    semilogy(Eb_No_dB,Pe(Ind_M,:),colors2(Ind_M));
    semilogy(New_Eb_No_dB(Ind_M,:),Pe(Ind_M,:),colors1(Ind_M));
end
%}

legend('M=2','M=2','M=4','M=4','M=8','M=8','M=16','M=16');      % Legenda nel grafico.
xlabel('E_b/N_0 (dB)');                                         % Etichetta delle ascisse.
ylabel('P(e)');                                                 % Etichetta delle ordinate.
title('Probabilità di errore');                                 % Titolo del grafico.
axis([0 10 10^(-4) 10^0]);                                      % Imposto dei limiti agli assi.

% Genero un nome per le figure:
name_figure=['SimplexVSBiortogonali_',num2str(data),' Figure'];
print(name_figure,'-dpng');     % Salvo il grafico in PNG.
print(name_figure,'-dpdf');     % Salvo il grafico in PDF.

% Chiudo tutte le figure perché se lasciate aperte danno problemi:
close all;

% Stampo a video un messaggio per avvisare l'utente che la simulazione è terminata:
fprintf(1,'Simulazione terminata!\n');
