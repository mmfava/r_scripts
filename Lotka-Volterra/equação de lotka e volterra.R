
######### --------------- Modelo de Lotka-Volterra --------------- #########

# Na matem�tica, as equa��es de Lotka-Volterra s�o um par de equa��es diferencia-
# is, n�o lineares e de primeira ordem, frequentemente utilizadas para descrever 
# din�micas nos sistemas biol�gicos, especialmente quando duas esp�cies interagem.

## Modelo de Lotka-Volterra para competi��o intraespecificia: 

# Na equa��o log�stica, o quociente N/K mede o efeito do crescimento de uma popu-
# la��o pela acr�scimo de um novo indiv�duo da mesma esp�cie (competi��o intra-
# espec�fica).

# dN/dt = rN(1 - N/K)

## Modelo de Lotka-Volterra para competi��o interespecifica:

# O efeito produzido pelo aparecimento de uma outra esp�cie, pode ser considerado
# acrescentando um termo que introduz as mudan�as que acontecem pelo aumento de 
# indiv�duos da segunda esp�cie (competi��o inter-espec�fica).

# dN1/dt = r1N1(1 - N1/K1 - a12N2/K1 (Efeito da popula��o 2 sobre a 1)
# dN2/dt = r2N2(1 - N2/K2 - a21N1/K2) (Efeito da popula��o 1 sobre a 2)

## Vari�veis envolvidas na equa��o de Lotka-Volterra:

# N = Tamanho da popula��o (em n�mero ou biomassa de indiv�duos)
# t = Tempo (em uma unidade qualquer)
# K = Capacidade suporte da popula��o (em n�mero ou biomassa de indiv�duos)
# r = Taxa intr�nseca de varia��o populacional (n�mero de indiv�duos / indiv�duos x
# tempo)a
# alfa = Coeficiente de competi��o representando o efeito da esp�cie 2 na esp�cie 1
# beta = Coeficiente de competi��o representando o efeito da esp�cie 1 na esp�cie 2

## Interpreta��o:

# O alfa e o beta medem a capacidade de cada esp�cie para neutralizar a outra es-
# p�cie em rela��o a s� mesmo. 
# Se o alfa ou beta <1, ent�o cada esp�cie t�m maior controle sobre o seu pr�prio
# crescimento. 
# Se o alfa ou o beta >1, ent�o a esp�cie x tem capacidade de excluir a esp�cie y.

## Gr�ficos

# Tradicionalmente, analisamos o sistema de equa��es de Lotka-Volterra � analisa-
# -do em graficos. 
# Infelizmente, essa forma de an�lise n�o � extens�vel a ??? 3 esp�cies (apenas 2).

## -- Fun��o para o calculo -- ##

compete=function(n01,n02,tmax,r1,r2,k1,k2,alfa,beta)
{
  resulta=matrix(0, ncol=3, nrow=tmax)
  resulta[,1]=0:(tmax-1)
  resulta[1,c(2,3)]=c(n01,n02)
  for(t in 2:tmax)
  {
    nsp1=resulta[(t-1),2]
    nsp2=resulta[(t-1),3]
    resulta[t,2]=nsp1 + r1*nsp1*((k1-nsp1-alfa*nsp2)/k1)
    resulta[t,3]=nsp2 + r2*nsp2*((k2-nsp2-beta*nsp1)/k2)
    if (resulta[t,2]<1)  
    {
      resulta[t,2]=0
    }
    if (resulta[t,3]<1)  
    {
      resulta[t,3]=0
    }
  }
  old=par(mfrow=c(1,2))
  plot(resulta[,1],resulta[,2],ylim=c(0,max(na.omit(resulta[,2:3]))),type="l",lty=1,xlab="time (t)",ylab="Population size", main="Population Growth")
  lines(resulta[,1],resulta[,3],lty=2)
  plot(resulta[,2],resulta[,3],type="l",col="red",xlab="N1",ylab="N2",ylim=c(0,max(c(na.omit(resulta[,3]),k1/alfa,k2))),xlim=c(0,max(c(na.omit(resulta[,2]),k2/beta,k1))), main="Isoclines")
  segments(0,k1/alfa,k1,0,lty=1)
  segments(0,k2,k2/beta,0,lty=2)
  legend("topright", legend=c("Sp. 1", "Sp. 2"), lty=c(1,2), bty="n", cex=0.8)
  return(resulta)
}

## -- Competi��o -- ##

## ~~ Coexist�ncia ~~ ##
compete(n01=10, n02=10,r1=0.05, r2=0.03, k1=80, k2=50, alfa=1.2, beta=0.5, tmax=200)
compete(n01=80, n02=30,r1=0.05, r2=0.03, k1=80, k2=50, alfa=1.2, beta=0.5, tmax=200)
compete(n01=10, n02=55,r1=0.05, r2=0.03, k1=80, k2=50, alfa=1.2, beta=0.5, tmax=500)
compete(n01=90, n02=5,r1=0.05, r2=0.03, k1=80, k2=50, alfa=1.2, beta=0.5, tmax=800)
### Cen�rio 2 (sp2 vence): 1/beta e alfa > k1/k2 
compete(n01=10, n02=10,r1=0.05, r2=0.03, k1=80, k2=50, alfa=1.8, beta=0.5, tmax=750)
### Cen�rio 3 (sp1 vence):  k1/k2 < alfa e 1/beta 
compete(n01=10, n02=10,r1=0.05, r2=0.03, k1=80, k2=50, alfa=1.2, beta=0.7, tmax=10000)
### Cen�rio 4: 1/beta < k1/k2 < alfa (equilibrio instavel)
#compete(n01=10, n02=10,r1=0.05, r2=0.03, k1=80, k2=50, alfa=2.5, beta=1.2, tmax=50)
compete(n01=10, n02=10,r1=0.05, r2=0.03, k1=80, k2=50, alfa=2.5, beta=1.2, tmax=150)
compete(n01=10, n02=20,r1=0.05, r2=0.03, k1=80, k2=50, alfa=2.5, beta=1.2, tmax=50)
compete(n01=10, n02=20,r1=0.05, r2=0.03, k1=80, k2=50, alfa=2.5, beta=1.2, tmax=500)





