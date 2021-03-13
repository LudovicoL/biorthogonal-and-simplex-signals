% Inizio l'esecuzione eliminando le variabili in memoria e pulendo il terminale:
clear all;
clc;

% Ottengo da sistema data ed ora per valutare le prestazioni del ricevitore:
c=fix(clock);
anno=c(1);
mese=c(2);
giorno=c(3);
ore=c(4);
minuti=c(5);
secondi=c(6);
% Genero una stringa ordinata con data ed orario:
data=[num2str(anno),'-',num2str(mese),'-',num2str(giorno),'_',num2str(ore),'-',num2str(minuti),'-',num2str(secondi)];
% Genero una variabile per il nome del file da creare successivamente:
name_file=['Ortogonali_',num2str(data),'.txt'];

% Apro un nuovo file in cui salvare i risulati delle simulazioni e gli assegno automaticamente un nome dipendente dalla data di avvio del programma:
fid = fopen (name_file, 'w');

% Creo un vettore con i possibili colori dei grafici da stampare:
colors=['k' 'r' 'b' 'g' 'y' 'c' 'm'];

% Dati di simulazione:
M=[2 4 8 16];                           % Valori di M.
Lungh_M=length(M);                      % Lunghezza del vettore contenente i valori di M.
Eb_No_dB=[0:2:12];                      % Valori di Eb_No_dB (Considero solo da 0dB a 10dB).
No=1;                                   % No=1 per semplicità.
N_Errori=100;                           % Imposto un valore massimo di errori ammissibili.
MAX_Iter=10^7;                          % Imposto una soglia massima di iterazioni in modo che il programma non venga eseguito per un lasso di tempo troppo lungo.
Lungh_Eb_No_dB=length(Eb_No_dB);        % Lunghezza del vettore contenente i valori di Eb_No_dB.

% Calcolo 'Eb' a partire da 'Eb_No_dB':
Eb=No.*10.^(Eb_No_dB./10);

% Stampo a video due messaggi per avvisare l'utente che la simulazione è cominciata:
fprintf(1,'SEGNALI ORTOGONALI\n');
fprintf(1,'Simulazione in corso...\n');

% Creo una matrice per la Probabilità d'errore e la inizializzo di zeri:
Pe=zeros(Lungh_M, Lungh_Eb_No_dB);


for Ind_M=1:Lungh_M,                                % Scorro tutti i valori di M volta per volta.
    fprintf(fid, 'M: %d\n\n',M(Ind_M));             % Stampo il valore di M all'interno del file.
    
    for IT=1:Lungh_Eb_No_dB,                        % Scorro tutti i valori di Eb_No_dB volta per volta.
        % Stampo nel file un'etichetta che indica l'iterazione eseguita:
        fprintf(fid, 'Iterazione %d di %d (Eb_No=%d)\n',IT,Lungh_Eb_No_dB,Eb_No_dB(IT));
        % fprintf(1, 'Iterazione %d di %d (Eb_No=%d)\n',IT,Lungh_Eb_No_dB,Eb_No_dB(IT));
        
        % Ottengo minuti e secondi per una stima sulle prestazioni di ogni singola iterazione:
        c2=fix(clock);
        minuti2=c2(5);
        secondi2=c2(6);
        
        % Calcolo 'Es' dalla formula inversa:
        Es=(log(M(Ind_M))/log(2))*Eb(IT);
        
        % Inizializzo la variabile per il calcolo della Probabilità d'errore:
        Niter=0;            % Conteggio delle iterazioni.
        Errori=0;           % Conteggio degli errori.
        
        % Conto gli errori per ogni singolo valore di Eb_No_dB:
        while (Errori<N_Errori)&&(Niter<MAX_Iter)
            
            % Genero un indice di trasmissione intero casuale:
            Idx_TX=randi(M(Ind_M));
            
            % Creo il segnale trasmesso riempiendolo di zeri tranne nella posizione dell'indice di trasmissione dove è presente il valore 'radice di Es':
            S_TX=zeros(M(Ind_M),1);
            S_TX(Idx_TX)=sqrt(Es);
            
            % Genero il rumore:
            Noise=sqrt(No/2).*randn(M(Ind_M),1);

            % Sommo il rumore al segnale trasmesso e genero il segnale ricevuto:
            S_RX=S_TX+Noise;
            
            % Ottengo l'indice del valore massimo nel segnale ricevuto:
            [~, Idx_DEC]=max(S_RX);
            
            % Regola decisionale:
            if Idx_DEC~=Idx_TX,     % Se i valori degli indici sono diversi, è stato commesso un errore:
                Errori=Errori+1;
                % fprintf(fid, 'Eb_No=%d Errori=%d\n',Eb_No_dB(IT),Errori);
            end
            
            % Incremento il numero di iterazione:
            Niter=Niter+1;

        end
        
        % Calcola la probabilità d'erore per il valore di M corrente:
        Pe(Ind_M, IT)=Errori/Niter;
        
        % Ottengo minuti e secondi per una stima sulle prestazioni di ogni singola iterazione:
        c3=fix(clock);
        minuti3=c3(5);
        secondi3=c3(6);
        % Calcolo la differenza temporale:
        secondi_tot2=(((minuti3*60)+secondi3)-((minuti2*60)+secondi2));
        
        % Stampo nel file il resoconto per ogni valore di 'Eb_No_dB':
        fprintf(fid, 'Eb_No=%d Errori=%d\n',Eb_No_dB(IT),Errori);
        fprintf(fid,'Probabilità di errore: %d\n',Pe(IT));
        fprintf(fid,'Secondi trascorsi: %d\n\n',secondi_tot2);
        
    end
    
    % Vado a capo nel file per separare le varie M:
    fprintf(fid,'\n\n\n');
    
end

% Disegno il grafico:
semilogy(Eb_No_dB,Pe(1,:),colors(1));
hold;
grid on;
for Ind_M=2:Lungh_M
    semilogy(Eb_No_dB,Pe(Ind_M,:),colors(Ind_M));
end
legend('M=2','M=4','M=8','M=16');                       % Legenda nel grafico.
xlabel('E_b/N_0 (dB)');                                 % Etichetta delle ascisse.
ylabel('P(e)');                                         % Etichetta delle ordinate.
title('Probabilità di errore');                         % Titolo del grafico.
axis([0 10 10^(-4) 10^0]);                              % Imposto dei limiti agli assi.

% Genero un nome per le figure:
name_figure=['Ortogonali_',num2str(data),' Figure'];
print(name_figure,'-dpng');     % Salvo il grafico in PNG.
print(name_figure,'-dpdf');     % Salvo il grafico in PDF.

% Ottengo da sistema minuti e secondi per calcolare la differenza con i valori ottenuti quando è stato lanciato il programma:
c1=fix(clock);
minuti1=c1(5);
secondi1=c1(6);
secondi_tot=(((minuti1*60)+secondi1)-((minuti*60)+secondi));
% Stampo nel file il tempo di esecuzione totale:
fprintf(fid,'\n\nSecondi trascorsi: %d\n',secondi_tot);

% Chiudo il file aperto in precedenza:
fclose(fid);

% Esporto le variabili 'Eb_No_dB', 'Pe', 'M', 'data':
save('variables_ortogonali', 'Eb_No_dB', 'Pe', 'M', 'data');
% Esporto tutte le varabili del programma:
name_all_variables=['Ortogonali_variables_',num2str(data)];
save(name_all_variables);

% Chiudo tutte le figure perché se lasciate aperte danno problemi:
close all;

% Stampo a video un messaggio per avvisare l'utente che la simulazione è terminata:
fprintf(1,'Simulazione terminata!\n');
