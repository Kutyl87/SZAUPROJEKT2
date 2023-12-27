
% Wczytanie danych z pliku .tex
fileID = fopen('tx.tex','r');
data = textscan(fileID, '%s', 'Delimiter', '\n');
fclose(fileID);

% Przetworzenie danych w celu uzyskania liczbowych wartości
numericData2 = [];
for i = 1:length(data{1})
    % Pomijamy wiersze z komentarzami
    if ~startsWith(data{1}{i}, '%')
        textToProcess = data{1}{i};
        textWithoutIndex = regexprep(textToProcess, '\d+\t', '');

% Usunięcie spacji
textWithoutSpaces = strrep(textWithoutIndex, ' ', '');

% Usunięcie znaku '\\' na końcu
finalText = strrep(textWithoutSpaces, '\\', '');
finalText
        % Zakładamy, że dane są oddzielone znakami '&' i że ostatnia kolumna kończy się '\\' (typowe w tabelach LaTeX)
        % rowData = str2double(strsplit(data{1}{i}(1:end-2), '&'));
        numericData2 = [numericData2; str2double(finalText)]; %#ok<AGROW>
    end
end

% Teraz 'numericData' zawiera wczytane dane liczbowe
disp(numericData2);