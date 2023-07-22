#include "command.h"
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>


void chain_piping(const command_list *cs) {
    unsigned int n;
    if ((n = cs->n) == 0) {
        return;
    }

    int pipes[n - 1][2];
    for (unsigned int i = 0; i < n - 1; i++) {
        if (pipe(pipes[i]) == -1) {
            perror("Piping Failed!");
            exit(1);
        }
    }

    // Start executing commands in child processes
    for (unsigned int i = 0; i < n; i++) {
        pid_t pid = fork();
        if (pid == -1) {
            perror("Forking Failed!");
            exit(2);
        } else if (pid == 0) { // Child process //
            // Redirect stdin from prev cmd's pipe, if not the first cmd //
            if (i > 0) {
                if (dup2(pipes[i - 1][0], STDIN_FILENO) == -1) {
                    perror("dup2 Redir Input Failed!");
                    exit(3);
                }
            }

            // Redirect output to next cmd's pipe, if not last cmd //
            if (i < n - 1) {
                if (dup2(pipes[i][1], STDOUT_FILENO) == -1) {
                    perror("dup2 Redir Output Failed!");
                    exit(4);
                }
            }

            // Close all read/write ends in child processes //
            for (unsigned int j = 0; j < n - 1; j++) {
                close(pipes[j][0]);
                close(pipes[j][1]);
            }

            // Execute the cmd //
            execvp(cs->cmd[i][0], cs->cmd[i]);

            perror("execvp Failed!");
            exit(10);
        }
    }

    // Close all read/write ends in the parent process //
    for (unsigned int i = 0; i < n - 1; i++) {
        close(pipes[i][0]);
        close(pipes[i][1]);
    }

    // Wait for all child processes to terminate //
    for (unsigned int i = 0; i < n; i++) {
        int status;
        if (wait(&status) == -1) {
            perror("wait Failed!");
            exit(11);
        }
    }
}
