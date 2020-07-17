%{
/*
       Objetivo:
     		     Elaborar un analizador léxico en flex o ANCI C que reconozca los componentes léxicos pertenecientes a las clases descriptas.
                 Elaborar un analizador sintáctico descendente para una gramatica tipo LL para el lenguaje pu+.
                 Elaborar un analizador Semantico que genere la Traduccion.

       Autores: Cuevas Salgado Carlos
                Galindo Chávez Lisset América

       Fecha de elaboración: {Inicio: 17 de Noviembre de 2018
                              Termino: 21 de Noviembre de 2018}

     	Funciones: 
     	Se utiliza para encontrar el valor en las tablas estaticas
			int buscaValor(char** tabla,char* valor);
     	
     	Se utiliza para buscar los simboloes dentro de la tabla de simbolos
     		int buscarSimbolo(struct tabla_de_simbolos* tabla_simb, char* simb) ;
     	
     	Se Utiliza para agregar simbolos a la tabla de simbolos
     		int agregarSimbolo(struct tabla_de_simbolos *, char *);
		
		Se utiliza para imprimir la tabla de simbolos
			void mostrarSimbolo(struct tabla_de_simbolos *);
		
		Se utiliza para agregar cadenas a la tabla de cadenas
			int agregarCadena(struct tabla_de_cadenas *, char *);
		
		Se utiliza para imprimir el contenido de la tabla cadenas
			void mostrarCadena(struct tabla_de_cadenas *);
		
		Se utiliza para agregar los tokens  a la tabla
			void agregarTokens(struct tabla_de_tokens *tabla_token, int clase, float token){

		Se utiliza para mostrar el contenido de la tabla de los tokens
			void mostrarTokens(struct tabla_de_tokens *tabla_token){
        
        Se utiliza para iniciar el analisis de sintactico.
            void AnSint();

        Son para el análisis de la gramática    
                void AnSint();
        void G();
        void Z();
        void Y();
        void X();
        void D();
        char* J();
        void V(char* t);
        void S();
        void A();
        void H();
        void M();
        void P();
        void I();
        void N();
        void K();
        void R();
        void Q();
        void O();
        void E();
        void EP();
        void T();
        void TP();
        void F();
        void error();
        void Terminal(char terminal, int a);
        void sangria(int);
        
        Se utiliza para resaltar los errores    
            void error();

        Se utiliza en para el analisis de un elementos terminal 
            void Terminal(char terminal, int a);        
		
        Se envia una posicion y regresa el nombre de la tabla de simbolos    
        struct Simbolos* obtenerSimbolo(struct tabla_de_simbolos * tabla_simb, float pos){
  
        Se envia una posicion y regresa la cadena guarda
        obtenerCadena(struct tabla_de_cadenas * tabla_cadena, float pos){
*/
FILE *Tokens;
FILE *Error;

//Se definen tablas estáticas
char *op_rel[][2] = {
	{".DIF.", "!"},
	{".IGL.", "q"},
    {".MN.",  "<"}, 
    {".MNI.", "l"},
    {".MY.",  ">"},
    {".MYI." , "g"}
};


char *pal_res[][2] = {
	{"Bul", "b"}, 
	{"Cadena", "c"},
	{"Cierto", "t"},
	{"Entero", "e"},
	{"Falso", "f"},
	{"Haz", "h"}, 
	{"Mientras", "m"}, 
	{"Para", "p"},
	{"Real", "d"},
	{"Si", "i"}, 
	{"Sino", "o"}
}; 

char *clases[] = {
	"Palabras reservadas",
    "Identificadores",
    "Simbolos especiales",
    "Operador de asignacion",
    "Operadores relacionales",
    "Operadores aritmeticos",
    "Constante cadena",
    "Constantes numericas enteras",
    "Constantes numericas reales"
};



//Se utiliza para encontrar el valor en las tablas estaticas
int buscaValor(char* tabla[][2],char* valor) {
	int i = 0;
	while (strcmp(valor,tabla[i][0]) != 0 && i<11)
		i++;
	return i;
}

struct Simbolos{
	int posicion;
    char * nombre;
    char * tipo;
    struct Simbolos * next;    
};

struct tabla_de_simbolos {
	struct Simbolos * cabeza;   
};

struct Cadenas{
	int posicion;
    char * cadena;
    struct Cadenas * next;    
};

struct tabla_de_cadenas {
	struct Cadenas * cabeza;   
};

struct Token{
	int clase;
    float token;
    struct Token * next;    
};

struct tabla_de_tokens {
	struct Token * cabeza;   
};

struct tabla_de_simbolos * tabla_simb;
struct tabla_de_cadenas * tabla_cad;
struct tabla_de_tokens * tabla_token;

struct tabla_de_simbolos * crearTablaSimbolos();
struct tabla_de_cadenas * crearTablaCadenas();
int agregarSimbolo(struct tabla_de_simbolos *, char *);
void mostrarSimbolo(struct tabla_de_simbolos *);
int agregarCadena(struct tabla_de_cadenas *, char *);
void mostrarCadena(struct tabla_de_cadenas *);

struct tabla_de_simbolos * crearTablaSimbolos(){
    tabla_simb = (struct tabla_de_simbolos*)malloc(sizeof(struct tabla_de_simbolos));
    tabla_simb->cabeza = NULL;
    
    return tabla_simb;
}

struct tabla_de_cadenas * crearTablaCadenas(){
    tabla_cad = (struct tabla_de_cadenas*)malloc(sizeof(struct tabla_de_cadenas));
    tabla_cad->cabeza = NULL;
    
    return tabla_cad;
}

struct tabla_de_tokens * crearTablaTokens(){
    tabla_token = (struct tabla_de_tokens*)malloc(sizeof(struct tabla_de_tokens));
    tabla_token->cabeza = NULL;
    
    return tabla_token;
}

int agregarSimbolo(struct tabla_de_simbolos * tabla_simbolo, char *nombre){
    struct Simbolos *simb = (struct Simbolos*)malloc(sizeof(struct Simbolos)); 
    char * simbAux = malloc(sizeof(nombre));
    strcpy(simbAux, nombre);
    simb->nombre = simbAux;
    simb->tipo = 0;
    
    if (tabla_simbolo->cabeza == NULL) {
    	simb->posicion = 0;
   	    tabla_simb->cabeza = simb;
    } else { 
        struct Simbolos *aux = tabla_simbolo->cabeza;
        int contador = 1;
        while(aux->next != NULL){
        	contador++;
	        aux = aux->next;
        }              
        simb->posicion = contador; 
        aux->next = simb;           
        simb->next = NULL;
    }
    return simb->posicion;    
}

void mostrarSimbolo(struct tabla_de_simbolos * tabla_simbolo){
    if(tabla_simbolo->cabeza == NULL){
	   printf("\n\tNo se contienen elementos\n");
    }
	else{	
		struct Simbolos *aux = tabla_simbolo->cabeza;
        printf("\n\t\tTABLA DE SIMBOLOS\n");
        printf("%15s%12s%12s\n", "Posicion","Nombre","Tipo");
        printf("%12d %14s %10s\n",aux->posicion,aux->nombre,aux->tipo);
        while(aux->next!= NULL){
        	aux = aux->next;
        	printf("%12d %14s %10s\n",aux->posicion,aux->nombre,aux->tipo);
        }
    }    
}

int buscarSimbolo(struct tabla_de_simbolos* tabla_simb, char* simb) {
	if(tabla_simb->cabeza == NULL){
	   return -1;
    } else{
    	struct Simbolos *aux = tabla_simb->cabeza;
    	if (strcmp(aux->nombre,simb)==0) {
   	    	return 0;
    	} else { 
			while(aux->next != NULL) {
				aux = aux->next;
				if (strcmp(aux->nombre,simb) == 0) {
					return (aux->posicion);
				}
			}
			return -1;
		}
	}
}

int agregarCadena(struct tabla_de_cadenas *tabla_cad, char *cadena){
    struct Cadenas *cadenas = (struct Cadenas*)malloc(sizeof(struct Cadenas)); 
    char * cadenaAux = malloc(sizeof(cadena));
    strcpy(cadenaAux, cadena);

    cadenas->cadena = cadenaAux;
    if (tabla_cad->cabeza == NULL) {
   		cadenas->posicion = 0;
   	    tabla_cad->cabeza = cadenas;
        tabla_cad->cabeza->next = NULL;
    } else { 
	    int contador = 1;
        struct Cadenas *aux = tabla_cad->cabeza;
        while(aux->next != NULL){   
        	contador++;
	        aux = aux->next;
    	}       
        cadenas->posicion = contador;
         
        aux->next = cadenas;           
        cadenas->next = NULL;
    }    
    return cadenas->posicion;
}

void mostrarCadena(struct tabla_de_cadenas *tabla_cad){
    if(tabla_cad->cabeza == NULL){
	   printf("\n\tNo se contienen elementos\n");
    }
    else {
	struct Cadenas *aux = tabla_cad->cabeza;
		printf("\n\n\t TABLA DE CADENAS\n");
        printf("%15s%12s\n", "Posicion","Cadena");
        printf("%11d %17s\n", aux->posicion, aux->cadena);
        while(aux->next!= NULL){
	        aux = aux->next;
            printf("%11d %17s\n", aux->posicion, aux->cadena);
        }
    }    
}

void agregarTokens(struct tabla_de_tokens *tabla_token, int clase, float token){
    struct Token *tok = (struct Token*)malloc(sizeof(struct Token)); 
    
    tok->clase = clase;
    tok->token = token;
    if (tabla_token->cabeza == NULL) {
   	    tabla_token->cabeza = tok;
        tabla_token->cabeza->next = NULL;
    } else { 
        struct Token *aux = tabla_token->cabeza;
        while(aux->next != NULL){   
	        aux = aux->next;
        }            
        aux->next = tok;           
        tok->next = NULL;
    }    
}

void mostrarTokens(struct tabla_de_tokens *tabla_token){
    if(tabla_token->cabeza == NULL){
	   printf("\n\tNo se contienen elementos\n");
    }
    else {
		struct Token *aux = tabla_token->cabeza;
		printf("\n\n\t TABLA DE TOKENS\n");
		printf("%15s%12s\n", "Clase","Token");
        if(aux->clase==8)
			printf("%12d %14.5f\n",aux->clase,aux->token);
	    else
	    	printf("%12d %14.0f\n",aux->clase,aux->token);
	    while(aux->next!= NULL){
		    aux = aux->next;
		    if(aux->clase==8)
				printf("%12d %14.5f\n",aux->clase,aux->token);
	        else
				printf("%12d %14.0f\n",aux->clase,aux->token);
	    }
    }    
}

//---------------------Análisis Sintactico--------------------------//
	char* Cadena;
	char atomo[1];
	int cont=0;
	char* Lineas;
	int BanderaError=0; 
    char* auxLinea;
//--------------------Análisis Semantico---------------------------//
    struct Token *ATR;
    char* auxiliarToken;
    FILE* Traduccion;
    char* tipo;
    int contsang = 0;

//  Se envia una posicion y regresa el valor (nombre) de la tabla de simbolos    
struct Simbolos* obtenerSimbolo(struct tabla_de_simbolos * tabla_simb, float pos){
    struct Simbolos *aux = tabla_simb->cabeza;
    if(pos==0){
        return (aux);
    }
    while(aux->next != NULL){
        aux=aux->next;
        if(aux->posicion==(int)pos){
            return (aux);
        }
    }            
}
  

  char* obtenerCadena(struct tabla_de_cadenas * tabla_cadena, float pos){
        struct Cadenas *aux = tabla_cadena->cabeza;
        if(pos==0){
        	return (aux->cadena);
        }
        while(aux->next != NULL){
            aux=aux->next;
            if(aux->posicion==(int)pos){
                return (aux->cadena);
            }
        }            
}

	void AnSint();
	void G();
	void Z();
	void Y();
	void X();
	void D();
	char* J();
    void V(char* t);
    void S();
	void A();
	void H();
	void M();
	void P();
	void I();
	void N();
	void K();
	void R();
	void Q();
	void O();
	void E();
	void EP();
	void T();
	void TP();
	void F();
    void error();
    void Terminal(char terminal, int a);
    void sangria(int);
/*------------------------*/
    void AnSint(){
    	atomo[0]=Cadena[cont++];
    	G();
    	if (atomo[0]=='\0' && BanderaError == 0){
    		printf("\nEl programa termino el analisis sintactico sin errores\n");
    	}else{
    	    error();	
    	} 
    }

    void G(){
    	if (atomo[0]=='['){
    		fprintf(Traduccion, "[");
            atomo[0]=Cadena[cont++];
    		ATR=ATR->next;
            contsang++;
            Z();
            fprintf(Traduccion, "\n");
            Terminal(']',0);
    		return;
    	} else 
    		error();
    }

    void Z(){
    	if (atomo[0]=='b'|| atomo[0]=='c'|| atomo[0]=='e'|| atomo[0]=='d'){
    		fprintf(Traduccion, "\n");
            D();
            Z();
    		return;
    	} else if(atomo[0]==']'){
            contsang--;
            return;		
    	} else if(atomo[0]=='a'||atomo[0]=='h'|| atomo[0]=='m'|| 
    		atomo[0]=='p'|| atomo[0]=='i'){
            Y();
    		return;
    	} else
			error();
    }
    
    void Y(){
    	if(atomo[0]=='a'||atomo[0]=='h'|| atomo[0]=='m'|| atomo[0]=='p'|| atomo[0]=='i'){
    		S();
    		X();
    		return;
    	} else 
			error();
    }

    void X(){
    	if(atomo[0]=='a'||atomo[0]=='h'|| atomo[0]=='m'|| atomo[0]=='p'|| atomo[0]=='i'){
    		Y();
            return; 	
    	} else if (atomo[0]==']'){
    		return;
    	} else
    		error();
    }

    void D(){
        if(atomo[0]=='b'|| atomo[0]=='c'|| atomo[0]=='e'|| atomo[0]=='d'){
            sangria(contsang);
            tipo = J();
    		Terminal('a',1);
    		V(tipo);
    		return;
    	} else 
    		error();		
    }

    char * J(){
        if(atomo[0]=='b'){
        	atomo[0]=Cadena[cont++];
        	ATR=ATR->next;
            fprintf(Traduccion,"Bul ");
            return pal_res[0][0];
        } else if(atomo[0]=='c'){
        	atomo[0]=Cadena[cont++];
        	ATR=ATR->next;
            fprintf(Traduccion,"Cadena ");
            return pal_res[1][0];
        } else if (atomo[0]=='e'){
        	atomo[0]=Cadena[cont++];
            ATR=ATR->next;
            fprintf(Traduccion,"Entero "); 
            return pal_res[3][0];
        } else if (atomo[0]=='d'){
        	atomo[0]=Cadena[cont++];
            ATR=ATR->next;
            fprintf(Traduccion,"Real "); 
        	return pal_res[8][0];
        } else
     		error();
    }

    void V(char * t){
    	if (atomo[0]==','){
    		atomo[0]=Cadena[cont++];
            ATR=ATR->next;
            fprintf(Traduccion,", "); 
            Terminal('a',1);
    		V(tipo);
    		return;
    	} else if (atomo[0]==';'){
    		atomo[0]=Cadena[cont++];
    		ATR=ATR->next;
            fprintf(Traduccion,";"); 
            return;
    	} else
    		error();
    }
    
    void S(){
    	
        if(atomo[0]=='a'){
       		fprintf(Traduccion, "\n");
            sangria(contsang);
            A();
    		Terminal(';',0);
    		return;	
    	} else if (atomo[0]=='h'){
    		fprintf(Traduccion, "\n");
            H();
    		return;
    	} else if (atomo[0]=='m'){
    		fprintf(Traduccion, "\n");
            M();
    		return;
    	} else if (atomo[0]=='p'){
    		fprintf(Traduccion, "\n");
            P();
    		return;
    	} else if (atomo[0]=='i'){
    		fprintf(Traduccion, "\n");
            I();
    		return;
    	} else 
    		error();
    }

    void A(){
    	if (atomo[0]=='a'){
            atomo[0]=Cadena[cont++];
    		struct Simbolos * aux_s = obtenerSimbolo(tabla_simb,ATR->token);
    		if (aux_s->tipo==0){
            	printf("Error variable: %s NO declarada\n",aux_s->nombre);
            	fprintf(Error,"Variable %s NO utilizada error\n",aux_s->nombre);
            }
    		fprintf(Traduccion,"%s ",aux_s->nombre);
            ATR=ATR->next;
            Terminal('=',0);
            fprintf(Traduccion, " ");
            K();
    		return;
    	} else 
    	 	error();
    }
 	
 	void H(){
 		if (atomo[0]=='h'){
 			atomo[0]=Cadena[cont++];
 			sangria(contsang);
            fprintf(Traduccion,"Haz");
            ATR=ATR->next;
            Terminal('[',0);
            contsang++;
            Y();
 			contsang--;
            fprintf(Traduccion,"\n");
            sangria(contsang);
            Terminal(']',0);
            if (atomo[0]=='m'){
                atomo[0]=Cadena[cont++];
                fprintf(Traduccion," Mientras");
                ATR=ATR->next;
            }
 			Terminal('(',0);
 			R();
 			Terminal(')',0);
 			Terminal(';',0);
            fprintf(Traduccion,"\n");
 			return;
 		} else
 		  error();
 	}	  

 	void M(){
 		if (atomo[0]=='m'){
 			atomo[0]=Cadena[cont++];
 			sangria(contsang);
            fprintf(Traduccion,"Mientras");
            ATR=ATR->next;
            Terminal('(',0);
 			R();
 			Terminal(')',0);
 			Terminal('[',0);
            contsang++;
 			Y();
            contsang--;
            fprintf(Traduccion, "\n");
            sangria(contsang);
            Terminal(']',0);
 			fprintf(Traduccion, "\n");
            return;
     	} else
     	    error();	
 	}

 	void P(){
 		if(atomo[0]=='p'){
 			atomo[0]=Cadena[cont++];
            sangria(contsang);
            fprintf(Traduccion,"Para");
            ATR=ATR->next;
 			Terminal('(',0);
 			A();
 			Terminal(';',0);
 			R();
 			Terminal(';',0);
 			A();
 			Terminal(')',0);
 			Terminal('[',0);
 			contsang++;
            Y();
            contsang--;
            fprintf(Traduccion, "\n");
            sangria(contsang);
            Terminal(']',0);
 			return;
 		} else 
 			error();
 	}

 	void I(){
 		if (atomo[0]=='i'){
 			atomo[0]=Cadena[cont++];
 			sangria(contsang);
            fprintf(Traduccion,"Si");
            ATR=ATR->next;
            Terminal('(',0);
 			R();
 			Terminal(')',0);
 			Terminal('[',0);
 			contsang++;
            Y();
            contsang--;
            fprintf(Traduccion, "\n");
            sangria(contsang);
            Terminal(']',0);
			N();

 			return;
 		} else
 			error();
 	} 

 	void N(){
 		if (atomo[0]=='a'||atomo[0]=='h'|| atomo[0]=='m'|| 
 			atomo[0]=='p'|| atomo[0]=='i'||atomo[0]==']'){
 			fprintf(Traduccion,"\n");
 			return;
 		} else if (atomo[0]=='o'){
 			atomo[0]=Cadena[cont++];
 			fprintf(Traduccion," Sino");
            ATR=ATR->next;
            Terminal('[',0);
            contsang++;
            Y();
            contsang--;
            fprintf(Traduccion, "\n");
            sangria(contsang);
            Terminal(']',0);
 			return;
 		} else 
 			error();
 	}

    void K(){
    	if (atomo[0]=='s'){
    		atomo[0]=Cadena[cont++];
    		fprintf(Traduccion,"%s", obtenerCadena(tabla_cad,ATR->token));
            ATR=ATR->next;
            return;
    	} else if (atomo[0]=='('||atomo[0]=='a'||atomo[0]=='n'||atomo[0]=='r'){
    		E();
    		return;
    	} else if (atomo[0]=='t'){
    		atomo[0]=Cadena[cont++];
    		fprintf(Traduccion,"Cierto");
            ATR=ATR->next;
            return;
    	} else if (atomo[0]=='f'){
    		atomo[0]=Cadena[cont++];
    		fprintf(Traduccion,"Falso");
            ATR=ATR->next;
            return;
    	} else 
    		error();
    }

    void R(){
    	if (atomo[0]=='('||atomo[0]=='a'||atomo[0]=='n'||atomo[0]=='r'){
    		E();
    		Q();
    		return;
      	} else
      		error();    
    }

    void Q(){
    	if(atomo[0]=='!'||atomo[0]=='q'||atomo[0]=='<'||atomo[0]=='l'||atomo[0]=='>'||atomo[0]=='g'){
    		O();
    		E();
    		return;
    	} else if (atomo[0]==')'){
    		return;
        } else if (atomo[0]==';'){
            fprintf(Traduccion, "\n");
            return;
    	} else
    		error();
    }

    void O(){
        if (atomo[0]=='!'){
    		atomo[0]=Cadena[cont++];	
    		fprintf(Traduccion," != ");
            ATR=ATR->next;  
            return;
    	} else if (atomo[0]=='q'){
    		atomo[0]=Cadena[cont++];
    		fprintf(Traduccion," == ");
            ATR=ATR->next;  
            return;	
		} else if (atomo[0]=='<'){
			atomo[0]=Cadena[cont++];
			fprintf(Traduccion," < ");
            ATR=ATR->next;  
            return;	
    	} else if (atomo[0]=='l'){
    		atomo[0]=Cadena[cont++];
            fprintf(Traduccion," <= ");
            ATR=ATR->next;  
       		return;	
    	} else if (atomo[0]=='>'){
    		atomo[0]=Cadena[cont++];
    		fprintf(Traduccion," > ");
            ATR=ATR->next;  
            return;	
    	} else if (atomo[0]=='g'){
    		atomo[0]=Cadena[cont++];
    		fprintf(Traduccion," >= ");
            ATR=ATR->next;  
            return;
    	} else
    		error();				
    }

    void E(){
    	if(atomo[0]=='('||atomo[0]=='a'||atomo[0]=='n'||atomo[0]=='r'){
    		T();
    		EP();
    		return;
    	} else 
    	    error();
    }
    
    void EP(){
    	if (atomo[0]=='+'){
            atomo[0]=Cadena[cont++];
    		fprintf(Traduccion,"+");
            ATR=ATR->next;  
            T();
    		EP();
    	} else if (atomo[0]=='-'){
    		atomo[0]=Cadena[cont++];
    		fprintf(Traduccion, "-");
            ATR=ATR->next;
            T();
    		EP();
    	} else if (atomo[0]=='!'||atomo[0]=='q'||atomo[0]=='<'||atomo[0]=='l'||atomo[0]=='>'||atomo[0]=='g' || atomo[0]==')'||atomo[0]==';'){
    		return;
    	} else 
    	    error();
    }

    void T(){
    	if (atomo[0]=='('||atomo[0]=='a'||atomo[0]=='n'||atomo[0]=='r'){
    		F();
    		TP();
    		return;	
    	} else 
    	  error();
    }

    void TP(){
    	if (atomo[0]=='*'){
    		atomo[0]=Cadena[cont++];
            fprintf(Traduccion," * ");
            ATR=ATR->next;
            F();
    		TP();
    		return;
    	} else if (atomo[0]=='/'){
    		atomo[0]=Cadena[cont++];
            fprintf(Traduccion," / ");
            ATR=ATR->next;
    		F();
    		TP();
    		return;	
    	} else if (atomo[0]=='%'){
    		atomo[0]=Cadena[cont++];
            fprintf(Traduccion," %c ",37);
            ATR=ATR->next;
    		F();
    		TP();
    		return;	
    	} else if (atomo[0]=='+' || atomo[0]=='-' || atomo[0]=='!' || atomo[0]=='q'||atomo[0]=='<'||
                   atomo[0]=='l' || atomo[0]=='>' || atomo[0]=='g' || atomo[0]==')'||atomo[0]==';'){
    		return;
    	} else 
    		error();
    }

    void F(){
    	if(atomo[0]=='('){
    		atomo[0]=Cadena[cont++];
    		fprintf(Traduccion,"(");
            ATR=ATR->next;
            E();
    		Terminal(')',0);
    		return;
    	} else if(atomo[0]=='a'){
    		atomo[0]=Cadena[cont++];
            struct Simbolos *aux_s = obtenerSimbolo(tabla_simb,ATR->token);
            if (aux_s->tipo==0){
            	printf("Error variable: %s NO declarada\n",aux_s->nombre);
            	fprintf(Error,"Variable %s NO declarada error\n",aux_s->nombre);
            }
    		fprintf(Traduccion,"%s", aux_s->nombre);
            ATR=ATR->next;
            return;
    	} else if (atomo[0]=='n'){
    		atomo[0]=Cadena[cont++];
    		fprintf(Traduccion,"%.0f",ATR->token);
            ATR=ATR->next;
            return;	
    	} else if (atomo[0]=='r'){
    		atomo[0]=Cadena[cont++];
    		fprintf(Traduccion,"%.5f",ATR->token);
            ATR=ATR->next;
            return;	    			
    	} else 
    		error();
    }

    void Terminal(char terminal, int a){
    	if (atomo[0] == terminal){
    		atomo[0]=Cadena[cont++];
            if (a == 0){
                fprintf(Traduccion,"%c",terminal);
                ATR=ATR->next;
            } else if (a==1){
            	struct Simbolos * aux_s = obtenerSimbolo(tabla_simb,ATR->token);
                if(aux_s->tipo==0){
                	aux_s->tipo = tipo;
                	fprintf(Traduccion,"%s",aux_s->nombre);
                	ATR=ATR->next;
                } else {
                	printf("Error variable: %s YA declarada\n",aux_s->nombre);
                	fprintf(Error,"Variable %s YA declarada error\n",aux_s->nombre);
                	ATR=ATR->next;
                }
            }
    		return;
    	} else
    		error();
    }

   void error(){
        BanderaError=0;  	
        for (int ite = 0; ite <= strlen(Lineas) ; ite++){
            int LineasItera = Lineas[ite];
            if (LineasItera<0){LineasItera=LineasItera+256;}
            if (LineasItera >= cont){
                printf("\tEl error esta en la linea: %d, en el atomo numero: %d que es: %c\n",ite+1,cont,Cadena[cont]);
                fprintf(Error, "\tEl error esta en la linea: %d, en el atomo numero: %d que es: %c\n", ite+1,cont,Cadena[cont]);
                BanderaError=1;
                return;
            } 
        } 
        if (BanderaError==0){ 
            fprintf(Error, "\tHay un error en el atomo numero: %c, que es %d \n", cont,Cadena[cont]);    
            printf("\tHay un error en el atomo numero: %c, que es %d \n",cont,Cadena[cont]);
            BanderaError=1;
        }
   
   }

    void sangria(int sangria){
        int i;
        for(i=0; i<sangria; i++){ 
            fprintf(Traduccion, "\t");
        }
    }


%}

minuscula [a-z]
mayuscula [A-Z]
Letras ({minuscula}|{mayuscula}){0,7}
num [0-9]
rel DIF|IGL|MN|MNI|MY|MYI
punto \.
numEntero {num}+
numReal {num}+{punto}{num}+|{num}+{punto}{num}*|{num}*{punto}{num}+
exp (E|e)
signo (\+|-){0,1}
valExp {num}{1,2}
saltoDeLinea \n
blanco [ \t]

palRes 	Bul|Cadena|Cierto|Entero|Falso|Haz|Mientras|Para|Real|Si|Sino
iden {minuscula}{Letras}
simEsp \(|\)|,|;|\[|\] 
opAsig :=
opRel  {punto}{rel}{punto}
opArit (\+|-|\*|%|\/)
consCad  \".*\" 
consNumEntero {numEntero}|{numEntero}{exp}{signo}{valExp}
consNumReal {numReal}{exp}{signo}{valExp}|{numReal}
comentario \$\$.*
errorGeneral .

%%
{palRes} {	
			fprintf(Tokens, "%s es palabra reservada\n ", yytext);
			agregarTokens(tabla_token, 0, (float)buscaValor(pal_res, yytext));
			
			atomo[0]=pal_res[(int)buscaValor(pal_res, yytext)][1][0];
			Cadena=realloc(Cadena,(strlen(Cadena)+2)*sizeof(char)); 
			strncat(Cadena,atomo,1);
		 }

{iden}   {
			fprintf(Tokens, "%s es un identificador\n", yytext);
			int simb = buscarSimbolo(tabla_simb, yytext);
			if (simb == -1){
				simb = agregarSimbolo(tabla_simb, yytext);
			}
			agregarTokens(tabla_token, 1, (float)simb);
			
			atomo[0]= 'a';
			Cadena=realloc(Cadena,(strlen(Cadena)+2)*sizeof(char)); 
			strncat(Cadena,atomo,1);
		}

{simEsp} {
			fprintf(Tokens, "%s es un simbolo especial\n", yytext);
			agregarTokens(tabla_token, 2, (float)yytext[0]);
			
			atomo[0]=yytext[0];
			Cadena=realloc(Cadena,(strlen(Cadena)+2)*sizeof(char)); 
			strncat(Cadena,atomo,1);
		 }
{opAsig} {
			fprintf(Tokens, "%s es un opAsig\n", yytext);	
			agregarTokens(tabla_token, 3, (float)yytext[0]);

		    atomo[0]= '=';
		    Cadena=realloc(Cadena,(strlen(Cadena)+2)*sizeof(char)); 
			strncat(Cadena,atomo,1);
		}
{opRel}  {
			fprintf(Tokens, "%s es un opRel\n", yytext);
			agregarTokens(tabla_token, 4, (float)buscaValor(op_rel , yytext));
 			
 			atomo[0]= op_rel[(int)buscaValor(op_rel, yytext)][1][0];
			Cadena=realloc(Cadena,(strlen(Cadena)+2)*sizeof(char)); 
			strncat(Cadena,atomo,1);
		}
{opArit} {
			fprintf(Tokens, "%s es un opArit\n", yytext);
			agregarTokens(tabla_token, 5, (float)yytext[0]);
			
			atomo[0]=yytext[0];
			Cadena=realloc(Cadena,(strlen(Cadena)+2)*sizeof(char)); 
			strncat(Cadena,atomo,1);
		}
{consCad} {fprintf(Tokens, "%s es una cadena\n", yytext);
			int cad = agregarCadena(tabla_cad, yytext);
			agregarTokens(tabla_token, 6, (float)cad);
			
			atomo[0]='s';
			Cadena=realloc(Cadena,(strlen(Cadena)+2)*sizeof(char)); 
			strncat(Cadena,atomo,1);
		}
{consNumEntero} {
			fprintf(Tokens, "%s esa consNumEntero\n", yytext);
			agregarTokens(tabla_token, 7, atof(yytext));
			
			atomo[0]='n';
			Cadena=realloc(Cadena,(strlen(Cadena)+2)*sizeof(char)); 
			strncat(Cadena,atomo,1);
		}
{consNumReal} {
            fprintf(Tokens, "%s es consNumReal\n", yytext);
			agregarTokens(tabla_token, 8, atof(yytext));
			
			atomo[0]='r';
			Cadena=realloc(Cadena,(strlen(Cadena)+2)*sizeof(char)); 
			strncat(Cadena,atomo,1);
}		
{comentario} {/*Ignorar */}

{saltoDeLinea} {
                Lineas=realloc(Lineas,(strlen(Cadena)+2)*sizeof(char));
				atomo[0]=strlen(Cadena);
				strncat(Lineas,atomo,1); 
			   }

{blanco} {/*Ingorar*/}

{errorGeneral} { char *Auxiliar=" ";
	             if (strcmp(Auxiliar,yytext) != 0)
	                 fprintf(Error, "%s es un error lexico\n", yytext);
                     printf("%s es un error lexico\n", yytext );         
                }
%%

int main(int argc, char *argv[]){

	printf("\n------Analisis lexico------\n");

	tabla_simb = crearTablaSimbolos();
	tabla_cad = crearTablaCadenas(); 
	tabla_token = crearTablaTokens();

	Cadena=(char*)malloc(sizeof(char));
    Lineas=(char*)malloc(sizeof(char));	

	yyin = fopen(argv[1], "r");
    Tokens = fopen("Tokens.txt","w");
    Error = fopen("Error.txt","w");
    Traduccion = fopen("Traduccion.pu+","w");

    fprintf(Error, "\n-------Errores Lexicos--------\n");
    yylex();
    fclose(Tokens);
    
    printf("\n------Analisis sintactico------");
    printf("\nGramatica: %s\n",Cadena);
 
    fprintf(Error, "\n--------Errores Sintacticos y Semanticos---------\n");
    ATR = tabla_token->cabeza;  
    AnSint();
    fclose(Error);
    fclose(Tokens);
    fclose(Traduccion);
    mostrarSimbolo(tabla_simb);
    mostrarCadena(tabla_cad);
    mostrarTokens(tabla_token);
    
	return 0;
}