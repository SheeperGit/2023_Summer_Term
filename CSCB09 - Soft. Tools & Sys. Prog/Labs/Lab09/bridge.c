#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
    // FDs for foo, bar //
    int foo2bar[2]; // Pipe for foo->bar comms //
    int bar2foo[2]; // Pipe for bar->foo comms //
    
    if (pipe(foo2bar) < 0 || pipe(bar2foo) < 0) {
        perror("Failed to create pipes");
        exit(1);
    }

    pid_t fooPID, barPID;
    fooPID = fork();

    if (fooPID == -1) {
        perror("Failed to fork foo");
        exit(1);
    } 
    
    else if (fooPID == 0) {
        // Child process (foo) //
        close(foo2bar[0]); // Close unused read-end //
        close(bar2foo[1]); // Close unused write-end //

        dup2(bar2foo[0], 0); // Set stdin to read-end of bar2foo //
        dup2(foo2bar[1], 1); // Set stdout to write-end of foo2bar //

        // Execute foo //
        execl("./foo", "foo", "1", "2", NULL);

        perror("Failed to exec foo");
        exit(1);
    } 
    
    else {
        barPID = fork();

        if (barPID == -1) {
            perror("Failed to fork bar");
            exit(1);
        } 
        
        else if (barPID == 0) {
            // Child process (bar) //
            close(foo2bar[1]); // Close unused write-end //
            close(bar2foo[0]); // Close unused read-end //

            dup2(foo2bar[0], 0); // Set stdin to read-end of foo2bar //
            dup2(bar2foo[1], 1); // Set stdout to write-end of bar2foo //

            // Execute bar //
            execl("./bar", "bar", "1", "2", NULL);

            perror("Failed to exec bar");
            exit(1);
        } 
        
        else {
            // Parent process (bridge) //
            close(foo2bar[0]); // Close unused read-end //
            close(foo2bar[1]); // Close unused write-end //
            close(bar2foo[0]); // Close unused read-end //
            close(bar2foo[1]); // Close unused write-end //

            // Wait for both foo, bar to terminate //
            waitpid(fooPID, NULL, 0);
            waitpid(barPID, NULL, 0);
        }
    }

    return 0;
}
