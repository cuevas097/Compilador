%{
/*
       Objetivo:
     		     Elaborar un analizador léxico en flex o ANCI C que reconozca los componentes léxicos pertenecientes a las clases descriptas.

       Autores: Cuevas Salgado Carlos
                Galindo Chávez Lisset América

       Fecha de elaboración: {Inicio: 16 de septiembre de 2018
                              Termino: 25 de septiembre de 2018}

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
		
*/
FILE *Tokens;
FILE *Error;

//Se definen tablas estáticas
char *op_rel[] = {
	".DIF.", ".IGL.",
    ".MN.", ".MNI.",
    ".MY.", ".MYI."
};

char *pal_res[] = {
	"Bul", "Cadena", "Cierto", "Entero", "Falso", "Haz", "Mientras", "Para",
	"Real", "Si", "Sino"
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
int buscaValor(char** tabla,char* valor) {
	int i = 0;
	while (strcmp(valor,tabla[i]) != 0 && i<11)
		i++;
	return i;
}

struct Simbolos{
	int posicion;
    char * nombre;
    int tipo;
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
    simb->tipo = -1;
    
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
        printf("%12d %14s %10d\n",aux->posicion,aux->nombre,aux->tipo);
        while(aux->next!= NULL){
        	aux = aux->next;
        	printf("%12d %14s %10d\n",aux->posicion,aux->nombre,aux->tipo);
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


palRes 	Bul|Cadena|Cierto|Entero|Falso|Haz|Mientras|Para|Real|Si|Sino
iden {minuscula}{Letras}
simEsp \(|\)|,|;|\[|\] 
opAsig :=
opRel  {punto}{rel}{punto}
opArit (\+|-|\*|%|\/)
consCad  \".*\" 
consNumEntero {numEntero}
consNumReal {numReal}{exp}{signo}{valExp}|{numReal}
comentario \$\$.*
errorGeneral .

%%
{palRes} {	
			fprintf(Tokens, "%s es palabra reservada\n ", yytext);
			agregarTokens(tabla_token, 0, (float)buscaValor(pal_res, yytext));
		 }

{iden}   {
			fprintf(Tokens, "%s es un identificador\n", yytext);
			int simb = buscarSimbolo(tabla_simb, yytext);
			if (simb == -1){
				simb = agregarSimbolo(tabla_simb, yytext);
			}
			agregarTokens(tabla_token, 1, (float)simb);
		}

{simEsp} {
			fprintf(Tokens, "%s es un simbolo especial\n", yytext);
			agregarTokens(tabla_token, 2, (float)yytext[0]);
		 }
{opAsig} {
			fprintf(Tokens, "%s es un opAsig\n", yytext);	
			agregarTokens(tabla_token, 3, (float)yytext[0]);
		}
{opRel}  {
			fprintf(Tokens, "%s es un opRel\n", yytext);
			agregarTokens(tabla_token, 4, (float)buscaValor(op_rel , yytext));
		}
{opArit} {
			fprintf(Tokens, "%s es un opArit\n", yytext);
			agregarTokens(tabla_token, 5, (float)yytext[0]);
		}
{consCad} {fprintf(Tokens, "%s es una cadena\n", yytext);
			int cad = agregarCadena(tabla_cad, yytext);
			agregarTokens(tabla_token, 6, (float)cad);
		}
{consNumEntero} {
			fprintf(Tokens, "%s esa consNumEntero\n", yytext);
			agregarTokens(tabla_token, 7, atof(yytext));
		}
{consNumReal} {
            fprintf(Tokens, "%s es consNumReal\n", yytext);
			agregarTokens(tabla_token, 8, atof(yytext));
}		
{comentario} {/*Ignorar */}

{errorGeneral} { char *Aux=" ";
	             if (strcmp(Aux,yytext) != 0)
	                 fprintf(Error, "%s es un error lexico\n", yytext);}
%%

int main(int argc, char *argv[]){
	tabla_simb = crearTablaSimbolos();
	tabla_cad = crearTablaCadenas(); 
	tabla_token = crearTablaTokens();
	yyin = fopen(argv[1], "r");
    Tokens = fopen("Tokens.txt","w");
    Error = fopen("Error.txt","w");
    yylex();
    fclose(Tokens);
    fclose(Error);
    mostrarSimbolo(tabla_simb);
    mostrarCadena(tabla_cad);
	mostrarTokens(tabla_token);
	return 0;
}