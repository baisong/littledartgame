#import('dart:html');

void main() {
  // Removes "dart is not running" alert box
  clearShow();
  window.setTimeout(() {
    show('p!ng: move with arrow keys za~', alertClass: 'success');
  }, 3000);
  // Starts a new game board and writes to #canvas.
  new Game();
  new Board();
}

void show(String heading, [String message, String alertClass]) {
  document.query('#show .alert').classes.remove('display-none');
  document.query('#show .alert-heading').innerHTML = heading;
  if (message is String) {
    document.query('#show .alert-message').innerHTML = message;
  }
  if (alertClass is String) {
    document.query('#show .alert').classes = ['alert', 'alert-' + alertClass];
  }
}

void clearShow() {
  document.query('#show .alert').classes.add('display-none');
}

bool strEqualsAlert(String str) => str == 'alert';

class Board {
  
  Board() {
    CanvasElement canvas = document.query("#canvas");
    xc = MAX_X / 2;
    yc = MAX_Y / 2;
    ctx = canvas.getContext("2d");
    
    var lastPos = new Vector(xc, yc);
    var thisPos = new Vector(xc, yc);
    
    num money = 0;
    drawBoard(thisPos);
    // Handles moves
    final Set controls = new Set.from(['Up', 'Down', 'Left', 'Right']);
    final Set commands = new Set.from(['U+001B', 'U+0020', 'U+00BF']);
    document.on.keyDown.add((Event e) {
      KeyboardEvent ke=e;
      String keyId = ke.keyIdentifier;
      if (controls.contains(keyId)) {
        // show(ke.keyIdentifier, alertClass: 'success');  
        lastPos = thisPos;
        thisPos = parseMove(ke.keyIdentifier, lastPos);
        drawBoard(thisPos);

      } else {
        money = money + keyId.length;
        String moneyDisplay = "\$" + money.toString() + '.00';
        show(moneyDisplay, alertClass: 'success');
        //clearShow(); 
      }
    }, true);
  }
  
  void drawBoard(Vector thisPos) {
    ctx.clearRect(0, 0, MAX_X, MAX_Y);
    drawAvatar(thisPos.x, thisPos.y);
  }

  void drawAvatar(num x, num y) {
    num xUpperBound = Math.min(x, MAX_X_DRAW);
    num xBounded = Math.max(xUpperBound, MIN_X_DRAW);
    num yUpperBound = Math.min(y, MAX_Y_DRAW);
    num yBounded = Math.max(yUpperBound, MIN_Y_DRAW);
    ctx.beginPath();
    ctx.lineWidth = 2;
    ctx.fillStyle = PURPLE;
    ctx.strokeStyle = PURPLE;
    ctx.arc(xBounded, yBounded, RADIUS, 0, TAU, false);
    ctx.fill();
    ctx.closePath();
    ctx.stroke();
  }
  
  List parseMove(keyId, lastPos) {
    var upVtr = new Vector(0, -1);
    var downVtr = new Vector(0, 1);
    var leftVtr = new Vector(-1, 0);
    var rightVtr = new Vector(1, 0);
    
    List keyCoords = new List.from([upVtr, downVtr, leftVtr, rightVtr]);
    List keyIds = new List.from(['Up', 'Down', 'Left', 'Right']);
    
    return lastPos + keyCoords[keyIds.indexOf(keyId)] * SPEED;
  }
  
  CanvasRenderingContext2D ctx;
  num xc, yc;
  
  static final SPEED = 8;
  static final RADIUS = 15;
  static final SCALE_FACTOR = 4;
  static final TAU = Math.PI * 2;
  static final MAX_X = 600;
  static final MAX_Y = 400;
  static final CANVAS_PADDING = 15;
  static final MIN_X_DRAW = CANVAS_PADDING;
  static final MIN_Y_DRAW = CANVAS_PADDING;
  static final MAX_X_DRAW = MAX_X - CANVAS_PADDING;
  static final MAX_Y_DRAW = MAX_Y - CANVAS_PADDING;
  static final String PURPLE = "purple";
}

class Vector {
  num x, y;
  Vector(this.x, this.y);
  operator +(Vector other) => new Vector(x + other.x, y + other.y);
  operator *(num magnitude) => new Vector(x * magnitude, y * magnitude);
}

class Game {
  
  Game() {
    final Set commands = new Set.from(['U+001B', 'U+0020', 'U+00BF']);
    document.on.keyDown.add((Event e) {
      KeyboardEvent ke = e;
      if (commands.contains(ke.keyIdentifier)) {
        // show(ke.keyIdentifier, alertClass: 'success');  
        processCommand(ke.keyIdentifier);
      } else {
        show(ke.keyIdentifier, alertClass: 'error');
        //clearShow(); 
      }
    }, true);
    
    InputElement commandInput = document.query('#command');
    commandInput.on.keyDown.add((Event e) {
      KeyboardEvent ke = e;
      if (ke.keyIdentifier == 'Enter') {
        commandInput.blur();
        commandInput.value = "type '/' to enter a command";
        commandInput.classes.add('uneditable-text');
      }
    });
  }
  
  void processCommand(keyId) {
    if (keyId == 'U+00BF') {
      InputElement commandInput = document.query('#command');
      commandInput.classes.remove('uneditable-input');
      commandInput.focus();
      commandInput.value = '';
    }
  }
}
