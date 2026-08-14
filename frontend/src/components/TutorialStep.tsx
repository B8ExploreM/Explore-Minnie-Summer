import { useState } from 'react';
import type { TutorialStep as TutorialStepType } from '../data/steps';

interface Props {
  step: TutorialStepType;
  total: number;
}

export default function TutorialStep({ step, total }: Props) {
  const [copied, setCopied] = useState(false);

  const handleCopy = () => {
    navigator.clipboard.writeText(step.command).then(() => {
      setCopied(true);
      setTimeout(() => setCopied(false), 1500);
    });
  };

  return (
    <section className="step-card">
      <p className="step-counter">
        Step {step.id} of {total}
      </p>
      <h2>{step.title}</h2>
      <p>{step.instruction}</p>

      <div className="code-block">
        <code>{step.command}</code>
        <button onClick={handleCopy} className="copy-btn">
          {copied ? 'Copied!' : 'Copy'}
        </button>
      </div>

      <p className="explanation">{step.explanation}</p>
    </section>
  );
}
