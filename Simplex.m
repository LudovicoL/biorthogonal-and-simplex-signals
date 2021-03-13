% Inizio l'esecuzione eliminando le variabili in memoria e pulendo il terminale:
clear all;
clc;

% Importo le variabili dei segnali Simplex:
load('variables_simplex');

% Creo un vettore con i possibili colori dei grafici da stampare:
colors1=['k' 'r' 'b' 'g' 'y' 'c' 'm'];

Lungh_M=length(M);                              % Lunghezza del vettore contenente i valori di M.

% Stampo a video due messaggi per avvisare l'utente che la simulazione è cominciata:
fprintf(1,'SEGNALI SIMPLEX\n');
fprintf(1,'Simulazione in corso...\n');

% Disegno il grafico dei segnali Simplex:
semilogy(New_Eb_No_dB(1,:),Pe(1,:),colors1(1));
hold;
grid on;
for Ind_M=2:Lungh_M
    semilogy(New_Eb_No_dB(Ind_M,:),Pe(Ind_M,:),colors1(Ind_M));
end
legend('M=2','M=4','M=8','M=16');                               % Legenda nel grafico.
xlabel('E_b/N_0 (dB)');                                         % Etichetta delle ascisse.
ylabel('P(e)');                                                 % Etichetta delle ordinate.
title('Probabilità di errore');                                 % Titolo del grafico.
axis([0 10 10^(-4) 10^0]);                                      % Imposto dei limiti agli assi.
% xlim([0 10]);                                                 % Limiti sul solo asse delle ascisse.

% Genero un nome per le figure:
name_figure=['Simplex_',num2str(data),' Figure'];
print(name_figure,'-dpng');     % Salvo il grafico in PNG.
print(name_figure,'-dpdf');     % Salvo il grafico in PDF.

% Chiudo tutte le figure perché se lasciate aperte danno problemi:
close all;

% Stampo a video un messaggio per avvisare l'utente che la simulazione è terminata:
fprintf(1,'Simulazione terminata!\n');
