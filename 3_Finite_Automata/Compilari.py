class FiniteAutomaton:
    def __init__(self):
        self.states = set()
        self.alphabet = set()
        self.transitions = []
        self.final_states = set()

    def load_from_file(self, filename):
        try:
            with open(filename, 'r') as file:
                lines = file.readlines()

                for line in lines:
                    line = line.strip()

                    if line.startswith("states:"):
                        self.states = set(line[len("states:"):].strip().split(", "))

                    elif line.startswith("alphabet:"):
                        self.alphabet = set(line[len("alphabet:"):].strip().split(", "))

                    elif line.startswith("transitions:"):
                        transitions_str = line[len("transitions:"):].strip()
                        transitions = transitions_str.split("), ")
                        for transition in transitions:
                            transition = transition.replace("(", "").replace(")", "")
                            start_state, symbol, end_state = map(str.strip, transition.split(","))
                            self.transitions.append((start_state, symbol, end_state))

                    elif line.startswith("final_states:"):
                        self.final_states = set(line[len("final_states:"):].strip().split(", "))

        except FileNotFoundError:
            print(f"Error: File '{filename}' not found.")

    def display(self):
        print("Set of states:", self.states)
        print("Alphabet:", self.alphabet)
        print("Transitions:")
        for transition in self.transitions:
            print(f"  {transition[0]} --{transition[1]}--> {transition[2]}")
        print("Set of final states:", self.final_states)


# Main program
if __name__ == "__main__":
    fa = FiniteAutomaton()
    fa.load_from_file("FA.in")
    fa.display()
