const team = [
  {
    name: "Ramsa",
    linkedin: "https://linkedin.com/in/yourprofile",
  },
  {
    name: "Ezequiel",
    linkedin: "https://linkedin.com/in/teammate1",
  },
  {
    name: "Sepher",
    linkedin: "https://linkedin.com/in/teammate2",
  },
  {
    name: "Junior",
    linkedin: "https://linkedin.com/in/teammate3",
  },
  {
    name: "Dora",
    linkedin: "https://linkedin.com/in/teammate4",
  },
  {
    name: "Teammate 5",
    linkedin: "https://linkedin.com/in/teammate5",
  },
];

const AboutMe = () => {
  return (
    <div style={{ padding: "40px", maxWidth: "600px", margin: "0 auto" }}>
      <h2 style={{ textAlign: "center", marginBottom: "20px" }}>
        Meet the Team
      </h2>

      <ul style={{ listStyle: "none", padding: 0 }}>
        {team.map((member, index) => (
          <li
            key={index}
            style={{
              display: "flex",
              justifyContent: "space-between",
              padding: "10px 0",
              borderBottom: "1px solid #eee",
            }}
          >
            <span>{member.name}</span>
            <a
              href={member.linkedin}
              target="_blank"
              rel="noopener noreferrer"
              style={{ textDecoration: "none", color: "#0077b5" }}
            >
              LinkedIn
            </a>
          </li>
        ))}
      </ul>
    </div>
  );
};

export default AboutMe;