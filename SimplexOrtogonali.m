% Inizio l'esecuzione eliminando le variabili in memoria e pulendo il terminale:
clear all;
clc;

% Importo le variabili dei segnali Ortogonali:
load('variables_ortogonali');

% Creo un vettore con i possibili colori dei grafici da stampare:
colors1=['k' 'r' 'b' 'g' 'y' 'c' 'm'];
% colors2=['k:' 'r:' 'b:' 'g:' 'y:' 'c:' 'm:'];

Lungh_M=length(M);                              % Lunghezza del vettore contenente i valori di M.
Lungh_Eb_No_dB=length(Eb_No_dB);                % Lunghezza del vettore contenente i valori di Eb_No_dB.

% Stampo a video due messaggi per avvisare l'utente che la simulazione è cominciata:
fprintf(1,'SEGNALI SIMPLEX\n');
fprintf(1,'Simulazione in corso...\n');

% Genero i segnali Simplex semplicemente traslando gli ortogonali di un fattore -10*log10*(M/(M-1)):
for Ind_M=1:Lungh_M,
    for IT=1:Lungh_Eb_No_dB,
        New_Eb_No_dB(Ind_M, IT)=Eb_No_dB(IT)-10*log10(M(Ind_M)/(M(Ind_M)-1));
    end
end

% Disegno il grafico dei segnali Simplex a confronto con i segnali Ortogonali:
semilogy(Eb_No_dB,Pe(1,:),'k:');                    % Ortogonale: tratteggiato.
hold;
grid on;
semilogy(New_Eb_No_dB(1,:),Pe(1,:),colors1(1));     % Simplex: colorato normalmente.
semilogy(Eb_No_dB,Pe(2,:),'r:');
semilogy(New_Eb_No_dB(2,:),Pe(2,:),colors1(2));
semilogy(Eb_No_dB,Pe(3,:),'b:');
semilogy(New_Eb_No_dB(3,:),Pe(3,:),colors1(3));
semilogy(Eb_No_dB,Pe(4,:),'g:');
semilogy(New_Eb_No_dB(4,:),Pe(4,:),colors1(4));

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
% xlim([0 10]);                                                 % Limiti sul solo asse delle ascisse.

% Genero un nome per le figure:
name_figure=['SimplexVSOrtogonali_',num2str(data),' Figure'];
print(name_figure,'-dpng');     % Salvo il grafico in PNG.
print(name_figure,'-dpdf');     % Salvo il grafico in PDF.

% Esporto le variabili 'Eb_No_dB', 'Pe', 'M', 'data':
save('variables_simplex', 'New_Eb_No_dB', 'Eb_No_dB', 'Pe', 'M', 'data');
% Esporto tutte le varabili del programma:
name_all_variables=['Simplex_variables_',num2str(data)];
save(name_all_variables);

% Chiudo tutte le figure perché se lasciate aperte danno problemi:
close all;

% Stampo a video un messaggio per avvisare l'utente che la simulazione è terminata:
fprintf(1,'Simulazione terminata!\n');
