import React from 'react';
import {
  Route,
  Link,
  BrowserRouter as Router,
  Switch
} from 'react-router-dom';

import Home from './Home';
import add from './add';
import phonebook from './phonebook';

const App = () => (
  <Router>
    <React.Fragment>
      <ul>
        <li>
          <Link to ="/">Home</Link>
        </li>
        <li>
          <Link to ="/phonebook">Phonebook</Link>
        </li>
        <li>
          <Link to ="/add">Add Person to Phonebook</Link>
        </li>
      </ul>
      <Switch>
        <Route exact path="/" component={Home} />
        <Route exact path="/phonebook" component={phonebook} />
        <Route exact path="/add" component={add} />
        <Route default component={Home} />
      </Switch>
    </React.Fragment>
  </Router>
)

export default App;
