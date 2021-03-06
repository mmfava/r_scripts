
## ---- Cluster aglomerativo hierarquico ---- ##

# Pacotes necess�rios
library(ade4)
library(vegan)
library(gclus)
library(cluster)
library(RColorBrewer)
library(labdsv)

# Planilha de dados (livro do Boccard)
spe=read.csv("DoubsSpe.csv")
env=read.csv("DoubsEnv.csv")
spa=read.csv("DoubsSpa.csv")

# Observando a planilha de dados 
spe
env
spa

## --> Fun��o Hclust
## Deconstand: Comando do pacote Vegan para transforma��o/normaliza��o dos dados
spe.norm <- decostand(spe[,-1], "normalize")
spe.norm #dados transformados

## Para a cria��o de uma matriz de dist�ncias podemos usar tanto o comando "dist" como o "vegdist"
spe.ch <- vegdist(spe.norm, "euc") # Aplicando a normaliza��o com a dist�ncia euclidiana temos o 
                                   # m�todo de 'chord' para aglomera��o.          
spe.ch

## O comando 'hclust' monta o cluster com uso do m�todo 'single'
spe.ch.single <- hclust(spe.ch, method="single")

## Mostrando o cluster no formato gr�fico
plot(spe.ch.single)

## Arrumando o gr�fico
dev.new(title="Fish - Chord - Single linkage", width=12, height=8) # Abre uma janela extra 
                                                                   # com op��es extras para salvar fig
plot(spe.ch.single, main="Cluster - Single", ylab="Dist�ncia euclidiana", 
     xlab="", labels=rownames(spe), hang=-1, xpd=NA, sub ="")

# main: T�tulo do gr�fico
# ylab: nome do eixo Y
# xlab: nome do eixo x
# labels: nomes dos agrupados
# hang=-1: para deixar os nomes dos agrupados pareados
# sub="": para retirar a legenda em baixo

# E com outros m�todos de liga��o?
# M�todo de liga��o completa
spe.ch.complete <- hclust(spe.ch, method="complete")
summary(spe.ch.complete)
dev.new(title="Fish - Chord - Complete linkage", width=12, height=8)
plot(spe.ch.complete, main="Cluster - Completa", ylab="Dist�ncia euclidiana", 
     xlab="", labels=rownames(spe), hang=-1, xpd=NA, sub ="")

# Comparando os dois m�todos
dev.new(title="Fish - Chord - Complete linkage", width=12, height=8)
par(mfrow=c(1,2))
plot(spe.ch.single, main="Cluster - Single", ylab="Dist�ncia euclidiana", 
     xlab="", labels=rownames(spe), hang=-1, xpd=NA, sub ="")
plot(spe.ch.complete, main="Cluster - Completa", ylab="Dist�ncia euclidiana", 
     xlab="", labels=rownames(spe), hang=-1, xpd=NA, sub ="")
dev.off()

## !! M�todos completos tendem a formar grupos pequenos em fun��o de sua natureza matem�tica
##    exigir a liga��o entre todos os objetos em an�lise !!

## M�todo aglomer�tivo atraves da m�dia (UPGMA - Unweighted Pair Group Method with Arithmetic Mean)
spe.ch.UPGMA <- hclust(spe.ch, method="average")
dev.new(title="Fish - Chord - UPGMA", width=12, height=8)
plot(spe.ch.UPGMA, main="Cluster - UPGMA", ylab="Dist�ncia euclidiana", 
     xlab="", labels=rownames(spe), hang=-1, xpd=NA, sub ="")

## M�todo aglomer�tivo atr�ves do centr�ide
spe.ch.centroid <- hclust(spe.ch, method="centroid")
dev.new(title="Fish - Chord - Centroid", width=12, height=8)
plot(spe.ch.centroid, main="Cluster - Centr�ide", ylab="Dist�ncia euclidiana", 
     xlab="", labels=rownames(spe), hang=-1, xpd=NA, sub ="")
## !! Boccard: "Resultado deste m�todo � o pesadelo do ec�logo, e por isso � pouco utilizado"

## M�todo aglomer�tivo de Ward
spe.ch.ward <- hclust(spe.ch, method="ward.D2")
dev.new(title="Fish - Chord - Ward", width=12, height=8)
plot(spe.ch.ward, main="Cluster - Wars", ylab="Dist�ncia euclidiana", 
     xlab="", labels=rownames(spe), hang=-1, xpd=NA, sub ="")

## --- Mas qual m�todo � o melhor? Em demonstrar a realidade? --- ##

## --> Coeficiente cofen�tico
# Single
spe.ch.single.coph <- cophenetic(spe.ch.single)
cor(spe.ch, spe.ch.single.coph) # 0.5015116
# Complete
spe.ch.comp.coph <- cophenetic(spe.ch.complete)
cor(spe.ch, spe.ch.comp.coph) # 0.7567998
# UPGMA
spe.ch.UPGMA.coph <- cophenetic(spe.ch.UPGMA)
cor(spe.ch, spe.ch.UPGMA.coph) # 0.8537529
# Ward 
spe.ch.ward.coph <- cophenetic(spe.ch.ward)
cor(spe.ch, spe.ch.ward.coph) # 0.7821555

## -- Diagrama de shepard
dev.new(title="Cophenetic correlation", width=8, height=8)
par(mfrow=c(2,2))
plot(spe.ch, spe.ch.single.coph, xlab="Chord distance", 
     ylab="Cophenetic distance", asp=1, xlim=c(0,sqrt(2)), ylim=c(0,sqrt(2)),
     main=c("Single linkage", paste("Cophenetic correlation =",
                                    round(cor(spe.ch, spe.ch.single.coph),3))))
abline(0,1)
lines(lowess(spe.ch, spe.ch.single.coph), col="red")
plot(spe.ch, spe.ch.comp.coph, xlab="Chord distance", 
     ylab="Cophenetic distance", asp=1, xlim=c(0,sqrt(2)), ylim=c(0,sqrt(2)),
     main=c("Complete linkage", paste("Cophenetic correlation =",
                                      round(cor(spe.ch, spe.ch.comp.coph),3))))
abline(0,1)
lines(lowess(spe.ch, spe.ch.comp.coph), col="red")
plot(spe.ch, spe.ch.UPGMA.coph, xlab="Chord distance", 
     ylab="Cophenetic distance", asp=1, xlim=c(0,sqrt(2)), ylim=c(0,sqrt(2)),
     main=c("UPGMA", paste("Cophenetic correlation =",
                           round(cor(spe.ch, spe.ch.UPGMA.coph),3))))
abline(0,1)
lines(lowess(spe.ch, spe.ch.UPGMA.coph), col="red")
plot(spe.ch, spe.ch.ward.coph, xlab="Chord distance", 
     ylab="Cophenetic distance", asp=1, xlim=c(0,sqrt(2)), 
     ylim=c(0,max(spe.ch.ward$height)),
     main=c("Ward clustering", paste("Cophenetic correlation =",
                                     round(cor(spe.ch, spe.ch.ward.coph),3))))
abline(0,1)
lines(lowess(spe.ch, spe.ch.ward.coph), col="red")
dev.off()

# Dist�ncia de Gower (1983)
(gow.dist.single <- sum((spe.ch-spe.ch.single.coph)^2)) #  95.41391
(gow.dist.comp <- sum((spe.ch-spe.ch.comp.coph)^2)) # 43.46711
(gow.dist.UPGMA <- sum((spe.ch-spe.ch.UPGMA.coph)^2)) # 12.22276
(gow.dist.ward <- sum((spe.ch-spe.ch.ward.coph)^2)) # 1286.697

## ---- Fazendo um looping para calcular todos os m�todos de correla��o de uma �nica vez ---- ##
 
met=c('single', 'complete', 'average') # vetor com os m�todos de liga��o
ccc<-numeric(0) # vetor n�merico para armazenar as correla��es cofen�ticas

for (i in 1:3){ # inicia um loop para realiza��o do cluster para cada m�todos de liga��o
  cluster <- hclust(spe.ch, met[i])
  coph <- cophenetic(cluster)
  ccc[i] <- cor(spe.ch, coph)}

cluster
coph
ccc ## qual � o melhor?


