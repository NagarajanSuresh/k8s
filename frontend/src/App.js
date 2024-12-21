import React, { useState, useEffect } from 'react';
import axios from 'axios';

function App() {
  const server_url = "http://localhost:33000"
  console.log(server_url)
  const [message, setMessage] = useState('');
  const [responseData, setResponseData] = useState(null);
  const [getData, setGetData] = useState([]);

  useEffect(() => {
    // Fetch data from the backend when the component mounts
    axios.get(`${server_url}/get`) // Adjust the URL based on your backend
      .then((response) => {
        if (response.data.data) {
          setGetData(response.data.data);
        }
      })
      .catch((error) => {
        console.error('There was an error fetching data!', error);
      });
  }, []);

  const handlePost = async () => {
    if (message.trim()) {
      try {
        const response = await axios.post(`${server_url}/post`, { message });
        setResponseData(response.data);
        // Optionally, update the data view after posting
        setGetData([...getData, response.data.data]);
        setMessage('');
      } catch (error) {
        console.error('There was an error posting data!', error);
      }
    } else {
      alert('Please enter a message');
    }
  };

  return (
    <div className="App">
      <h1>React Express App</h1>

      <h2>Post Data</h2>
      <textarea
        value={message}
        onChange={(e) => setMessage(e.target.value)}
        placeholder="Enter a message to post"
      />
      <button onClick={handlePost}>Post</button>

      {responseData && (
        <div>
          <h3>Post Response:</h3>
          <p>{responseData.message}</p>
          <p>{responseData.data ? JSON.stringify(responseData.data) : 'No data returned'}</p>
        </div>
      )}

      <h2>Get Data</h2>
      <ul>
        {getData.map((dataItem, index) => (
          <li key={index}>{dataItem.data}</li>
        ))}
      </ul>
    </div>
  );
}

export default App;
