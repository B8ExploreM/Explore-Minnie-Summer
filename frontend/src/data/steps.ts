export interface TutorialStep {
  id: number;
  title: string;
  instruction: string;
  command: string;
  explanation: string;
}

export const steps: TutorialStep[] = [
  {
    id: 1,
    title: "Locate the hello_project directory",
    instruction: "Move into the Django app folder:",
    command: "cd hello_project/",
    explanation:
      "This is where views.py and urls.py live these two files control what the server sends back when someone visits a URL.",
  },
  {
    id: 2,
    title: "Confirm your location",
    instruction: "Print your current working directory:",
    command: "pwd",
    explanation:
      "A quick sanity check to make sure the previous cd actually landed you inside hello_project/.",
  },
  {
    id: 3,
    title: "List the directory contents",
    instruction: "See what files exist here:",
    command: "ls -l",
    explanation:
      "You should see views.py, urls.py, and a few other Django app files. This is your map before making any edits.",
  },
  {
    id: 4,
    title: "Inspect urls.py",
    instruction: "Print the contents of the URL configuration:",
    command: "cat urls.py",
    explanation:
      "urls.py maps incoming request paths (like /deploy/) to the Python function in views.py that should handle them.",
  },
  {
    id: 5,
    title: "Inspect views.py",
    instruction: "Print the contents of the view function:",
    command: "cat views.py",
    explanation:
      "This file contains the actual logic that runs when a matching URL is requested, and returns an HttpResponse back to the browser.",
  },
  {
    id: 6,
    title: "Edit the index page",
    instruction:
      "Open the HTML template in a text editor and change its content:",
    command: "nano templates/index.html",
    explanation:
      "This is the actual HTML rendered to the browser — try changing the heading, adding a paragraph, or tweaking the structure to get a feel for how Django serves front-end content.",
  },
  {
    id: 7,
    title: "Confirm your change is live",
    instruction: "Fetch the deployed page from the server:",
    command: "wget -qO- http://localhost/deploy/",
    explanation:
      "If everything is modified correctly, this prints your edited message straight from the running Django/Apache server proof your change reached the backend.",
  },
];
