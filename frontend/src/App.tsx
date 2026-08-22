import { useState } from 'react';
import './App.css';
import { steps } from './data/steps';
import TutorialStep from './components/TutorialStep';

function App() {
  const [currentIndex, setCurrentIndex] = useState(0);
  const current = steps[currentIndex];
  const isFirst = currentIndex === 0;
  const isLast = currentIndex === steps.length - 1;

  return (
    <>
      <header id="hero">
        <h1>Minnie Server Guide</h1>
        <p>A self-paced guide to editing and deploying your first Django view.</p>
      </header>

      <main id="tutorial">
        <TutorialStep step={current} total={steps.length} />

        <nav className="step-nav">
          <button
            disabled={isFirst}
            onClick={() => setCurrentIndex((i) => Math.max(0, i - 1))}
          >
            ← Previous
          </button>

          <div className="step-dots">
            {steps.map((s, i) => (
              <button
                key={s.id}
                className={`dot ${i === currentIndex ? 'active' : ''}`}
                onClick={() => setCurrentIndex(i)}
                aria-label={`Go to step ${s.id}`}
              />
            ))}
          </div>

          <button
            disabled={isLast}
            onClick={() => setCurrentIndex((i) => Math.min(steps.length - 1, i + 1))}
          >
            Next →
          </button>
        </nav>

        {isLast && (
          <div className="completion-banner">
            <h2>You've reached the final step!</h2>
            <p>
              Once your wget command shows your edited message, you've
              successfully completed the exercise.
            </p>
          </div>
        )}
      </main>
    </>
  );
}

export default App;
