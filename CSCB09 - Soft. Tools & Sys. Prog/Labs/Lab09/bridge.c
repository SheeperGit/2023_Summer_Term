#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

#define BUFSIZE 80

int main(){
    int foo2bar[2];
    int bar2foo[2];

    if(pipe(foo2bar) == -1 || pipe(bar2foo) == -1){
        perror("Failed to creates pipe(s)!");
        return 2;
    }

    pid_t fooPID;
    if((fooPID = fork()) == -1){
        perror("Failed to fork!");
        return 3;
    }

    if(fooPID != 0){
        pid_t barPID;
        if((barPID = fork()) == -1){
            perror("Failed to fork!");
            return 3;
        }

        if(barPID != 0){
            // Parent Process (bridge) //
            close(bar2foo[1]);
            close(foo2bar[0]);
            close(bar2foo[0]);
            close(foo2bar[1]);
            wait(NULL);
        }

        else{
            // Child Process (foo) //
            close(bar2foo[1]);
            close(foo2bar[0]);

            char in[BUFSIZE];
            char out[BUFSIZE];
            
            snprintf(in, BUFSIZE, "%d", bar2foo[0]);
            snprintf(out, BUFSIZE, "%d", foo2bar[1]);
            
            execlp("./foo", "./foo", in, out, (char *)NULL);
            perror("Failed to exec!");
            exit(1);
        }
    }
    
    else{
        // Child process (bar) //
        close(bar2foo[0]);
        close(foo2bar[1]);

        char in[BUFSIZE];
        char out[BUFSIZE];
            
        snprintf(in, BUFSIZE, "%d", foo2bar[0]);
        snprintf(out, BUFSIZE, "%d", bar2foo[1]);

        execlp("./bar", "./bar", in, out, (char *)NULL);
        perror("Failed to exec!");
        exit(1);
    }
}
