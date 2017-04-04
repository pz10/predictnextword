Data Science Capstone Project
========================================================
author: 
date: 
autosize: true

*NextWordPrediction* Shiny App,

a Data Product developed as a Capstone Project of the 
[**Data Science specialization**] (https://www.coursera.org/specializations/jhu-data-science) 
(*Johns Hopkins University* and *Coursera.org*)

Main goal
========================================================
* Development of a *shiny* App to predict the next word of a given text string.

Developed competencies:
* research capabilities (by fast learning a new topic such as *Natural Language processing* and *text mining* and associated tools in R)
* exploratory data analysis
* (big) data manipulation
* model construction and evaluation (efficiency and accuracy)
* optimization of computing resources (RAM and run time) 
* implementation of a Data Product (shiny app user interface)


Methodology
========================================================
1_ analysis a large corpus of text documents (70 million words, 400 MB; news, twitter and blogs).

2_ the corpus is divided in *train* (60%) and *test* (40%) sets

3_ a set of tools are developed for data cleaning and manipulation (e.g. conversion to lower case, removal of punctuation, symbols, twitter, web pages, ...)

4_ development of [N-gram models](https://en.wikipedia.org/wiki/N-gram) using the *train* set. In simple wording, they are frequency-ranked tables. The following models were considered: 2-gram : 7-gram (no [stopword](https://en.wikipedia.org/wiki/Stop_words) removal), 2-gram : 4-gram (after stopword removal) and 2-gram : 4-gram (after stopword removal and considering long-distance relations, i.e. up to 3 words)

Methodology
========================================================
5_ construction of a prediction algorithm based on those models. Each entry (row) of each ranked-table (N-gram model) is given a score based on the number of matches with a given input string (score = N-gram order - N matches -1; e.g. input = "the man", 3-Gr ="the woman is", associated predicted word ="is", score =3-1-1=1). All entries within a table are sorted by score. For each score, predicted-word frequencies are computed. Then, all tables are combined. A rank of predicted-word is computed, sorting by score (minimum score first), then by N-gram order (higher order first, no stopworded first) and finally by frequency of the predicted-word. By doing so, a back-off selection is implemented, allowing for a prediction when an incomplete match occur.

6_ evaluation of the algorithm  on the *test* set, mainly to optimize the size of each individual N-gram model.

NOTE: *quanteda* particullary *data.table* R packages have been extremly useful due to its fast performance (C implemented functions).


NextWordPrediction Shiny App
========================================================
1. Write or copy your text on the top left text-input box. Note that the text is echoed on the top box of the main pannel (top rigth)
2. click on "predict me!" button.
3. Find most likely prediction under "next word prediction"
4. Find alternative predictions under "alternative prediction(s)"
5. options: stopwords can be removed from the prediction by checking (default) the appropiate check-box. Note that "predict me!" button should be clicked again to refresh the prediction.

Link to ***shiny*** app: [https://ppzz.shinyapps.io/predictnextword/](https://ppzz.shinyapps.io/predictnextword/)
<!-- App code on github: [https://github.com/pz10/predictnextword](https://github.com/pz10/predictnextword) (not implemeted yet) -->
<!-- Link to this slide presentation [http://rpubs.com/pzuazo/predictnextword](http://rpubs.com/pzuazo/predictnextword) -->

<!-- predictnextword -->
<!-- Shiny app for predicting the next word of a given input text string -->


