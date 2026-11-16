export type SurveyQuestionSection = {
  id: string;
  title: string;
  data: SurveyQuestion[];
};

export type SurveyQuestion = {
  pos: number;
  text: string;
  answerType: "rating" | "input";
};

export const surveyQuestions: SurveyQuestionSection[] = [
  {
    id: "1",
    title: "Section 1: Teaching & Learning",
    data: [
      {
        pos: 1,
        text: "My teacher explains things in a way I understand.",
        answerType: "rating",
      },
      {
        pos: 2,
        text: "My teacher makes learning interesting and engaging.",
        answerType: "rating",
      },
      {
        pos: 3,
        text: "My teacher gives clear instructions about what we need to do.",
        answerType: "rating",
      },
      {
        pos: 4,
        text: "When I don't understand something, my teacher helps me.",
        answerType: "rating",
      },
      {
        pos: 5,
        text: "My teacher encourages me to ask questions and participate in class.",
        answerType: "rating",
      },
      {
        pos: 6,
        text: "My teacher has in-depth knowledge of the subject matter.",
        answerType: "rating",
      },
      {
        pos: 7,
        text: "My teacher utilizes multiple forms/tools (presentations, videos, models etc) to enhance my learning.",
        answerType: "rating",
      },
    ],
  },
  {
    id: "2",
    title: "Section 2: Classroom Environment",
    data: [
      {
        pos: 8,
        answerType: "rating",
        text: "My teacher creates a classroom where everyone feels respected.",
      },
      {
        pos: 9,
        answerType: "rating",
        text: "My teacher makes sure we follow classroom rules and behave well.",
      },
      {
        pos: 10,
        answerType: "rating",
        text: "My teacher helps create a positive and fun learning environment.",
      },
      {
        pos: 11,
        answerType: "rating",
        text: "I feel comfortable sharing my ideas and opinions in this class.",
      },
      {
        pos: 12,
        answerType: "rating",
        text: "My teacher is fair to all students in the class.",
      },
    ],
  },
  {
    id: "3",
    title: "Section 3: Communication and Feedback",
    data: [
      {
        pos: 13,
        answerType: "rating",
        text: "My teacher gives me helpful feedback on my work.",
      },
      {
        pos: 14,
        answerType: "rating",
        text: "My teacher listens to my concerns and ideas.",
      },
      {
        pos: 15,
        answerType: "rating",
        text: "My teacher lets me know how I can improve my learning.",
      },
      {
        pos: 16,
        answerType: "rating",
        text: "My teacher helps me understand how well I'm doing in class.",
      },
    ],
  },
  {
    id: "4",
    title: "Section 4: Overall Experience",
    data: [
      {
        pos: 17,
        answerType: "rating",
        text: "I enjoy being in this class.",
      },
      {
        pos: 18,
        answerType: "rating",
        text: "I am learning a lot in this class.",
      },
      {
        pos: 19,
        answerType: "rating",
        text: "My teacher cares about how well I do in school.",
      },
    ],
  },
  {
    id: "5",
    title: "Section 5: Open-Ended Questions",
    data: [
      {
        pos: 20,
        answerType: "input",
        text: "What do you like most about this class or your teacher?",
      },
      {
        pos: 21,
        answerType: "input",
        text: "What do you think your teacher could do to improve the class?",
      },
      {
        pos: 22,
        answerType: "input",
        text: "Is there anything else you would like to share about your experience in this class?",
      },
    ],
  },
];
