/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   tbo_completion.c                                   :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: mechard <mechard@student.42.fr>            +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/02/08 14:41:26 by mechard           #+#    #+#             */
/*   Updated: 2024/02/08 14:55:04 by mechard          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>
#include <string.h>

// Structure pour stocker les arguments et leurs descriptions
typedef struct {
    char *arg;
    char *description;
} Argument;

// Fonction pour afficher la liste des arguments disponibles
void print_arguments(char *prefix) {
    
	// test
	printf("Test");
	
	// Liste des arguments disponibles avec leurs descriptions
    Argument arguments[] = {
        {"-c", "Configurer la commande"},
        {"-g", "Opérations GitHub"},
        {"-i", "Opérations Intra"},
        {"-p", "Spécifier le chemin"},
        {"-f", "Spécifier le dossier"},
        {"-m", "Déplacement"},
        {"-u", "Mise à jour"},
        {"-cl", "Clonage"},
        {"-p", "Push"},
        {"-a", "Ajout"},
        {"-d", "Suppression"},
        {"-m", "Déplacement"}, // Vous avez utilisé deux fois "-m"
        {"-a", "Tous"},         // Vous avez utilisé deux fois "-a"
        {"-c", "Choisir"},      // Vous avez utilisé deux fois "-c"
        {NULL, NULL} // Marqueur de fin
    };
    
	// Parcourir la liste des arguments et les afficher
    for (int i = 0; arguments[i].arg != NULL; i++) {
        // Vérifier si l'argument commence par le préfixe spécifié
        if (strncmp(arguments[i].arg, prefix, strlen(prefix)) == 0) {
            printf("%s\t%s\n", arguments[i].arg, arguments[i].description);
        }
    }
}
