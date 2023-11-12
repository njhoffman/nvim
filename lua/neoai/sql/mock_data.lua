local mock_data = {
  {
    prompt_content = 'What differentiates the different AI models?',
    prompt_role = 'user',
    response_role = 'assistant',
    model = 'gpt-3.5-turbo',
    project = 'neoai',
    response_content = "There are several factors that differentiate different AI models:\
\
1. Architecture: The architecture of an AI model refers to its underlying structure and design. Different models use different architectures, such as Deep Neural Networks (DNNs), Convolutional Neural Networks (CNNs), Recurrent Neural Networks (RNNs), Transformers, or a combination of these architectures. The choice of architecture depends on the specific task the model is designed for.\
\
2. Training data: AI models are trained on large datasets, and the composition of the training data can vary across models. Different models may be trained on diverse or specialized datasets, which can influence their performance and generalization to real-world scenarios.\
\
3. Training methods: The techniques used for training AI models can differ. Some models may rely on supervised learning, where labeled data is used to teach the model, while others may use unsupervised learning or reinforcement learning techniques. The training methods employed can impact the model's learning capability and efficiency.\
\
4. Performance metrics: Performance metrics are utilized to evaluate AI models. Different models may have different metrics to assess their performance, such as accuracy, precision, recall, F1 score, etc. The choice of metrics depends on the specific task and the desired evaluation criteria.\
\
5. Optimizations and improvements: Models may undergo various optimizations and improvements over time. Researchers continually work on enhancing existing AI models by introducing architectural improvements, regularization techniques, optimization algorithms, or incorporating advancements from related fields such as computer vision, natural language processing, or speech recognition.\
\
6. Use cases: Different AI models are designed for specific use cases or tasks. For instance, some models may specialize in image recognition, language translation, question-answering, sentiment analysis, or speech synthesis. The purpose for which an AI model is developed greatly influences its architecture, training process, and performance.\
\
It's important to note that the above factors are not exhaustive, and models can vary in other aspects as well. The unique combination of these factors distinguishes one AI model from another, enabling them to excel in specific tasks or domains.",
  },
  ---
  ---
  ---
  {
    prompt_content = 'What is a reducer in react?',
    prompt_role = 'user',
    response_role = 'assistant',
    model = 'gpt-3.5-turbo',
    project = 'neoai',
    response_content = "In React, a reducer is a function that defines how the application's state should change in response to different actions. It is typically used in conjunction with the useReducer hook, which is a built-in React hook.\
\
A reducer takes two arguments: the current state and an action. The action is an object that describes the type of state update to be performed. Based on the action type, the reducer determines how the state should be modified and returns the new state.\
\
Here's a basic example of a reducer function in React:\
\
```jsx\
// Reducer function\
const reducer = (state, action) => {\
  switch (action.type) {\
    case 'INCREMENT':\
      return { ...state, count: state.count + 1 };\
    case 'DECREMENT':\
      return { ...state, count: state.count - 1 };\
    default:\
      throw new Error('Unknown action type');\
  }\
};\
\
// Using useReducer hook in a component\
const MyComponent = () => {\
  const [state, dispatch] = React.useReducer(reducer, { count: 0 });\
\
  const increment = () => {\
    dispatch({ type: 'INCREMENT' });\
  };\
\
  const decrement = () => {\
    dispatch({ type: 'DECREMENT' });\
  };\
\
  return (\
    <div>\
      Count: {state.count}\
      <button onClick={increment}>Increment</button>\
      <button onClick={decrement}>Decrement</button>\
    </div>\
  );\
};\
```\
\
In this example, the reducer function takes the current state and an action as input. It checks the action type and performs the appropriate state update. The useReducer hook is used to create the state and the dispatch function, which is responsible for sending actions to the reducer. The state is accessed through the `state` variable returned by the useReducer hook.\
\
Reducers provide a predictable way to manage state updates in React applications, especially for more complex state management scenarios. They help to separate the state modification logic from the component itself, making it easier to manage and maintain the application state.",
  },
}
return mock_data
