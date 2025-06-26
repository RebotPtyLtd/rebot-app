// WireMock Test Data Generator
// Run this script to generate comprehensive test data for your CRUD API

const fs = require('fs');

// Sample data arrays for generating realistic content
const officeNames = [
  "Downtown Branch", "Westside Office", "Tech Hub", "Central Plaza", "Harbor View",
  "Innovation Center", "Corporate Tower", "Business Park", "Metro Station", "Riverside Complex"
];

const firstNames = [
  "John", "Jane", "Alice", "Bob", "Carol", "David", "Emma", "Frank", "Grace", "Henry",
  "Ivy", "Jack", "Karen", "Leo", "Mia", "Noah", "Olivia", "Paul", "Quinn", "Rachel",
  "Sam", "Tina", "Uma", "Victor", "Wendy", "Xavier", "Yara", "Zoe", "Alex", "Blake"
];

const lastNames = [
  "Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis", "Rodriguez", "Martinez",
  "Hernandez", "Lopez", "Gonzalez", "Wilson", "Anderson", "Thomas", "Taylor", "Moore", "Jackson", "Martin",
  "Lee", "Perez", "Thompson", "White", "Harris", "Sanchez", "Clark", "Ramirez", "Lewis", "Robinson"
];

const itemTitles = [
  "Server Maintenance Schedule", "Office Supplies Inventory", "Security Protocol Updates", "Network Upgrade Project",
  "Employee Training Schedule", "Budget Review Meeting", "Client Presentation Prep", "Software License Renewal",
  "Equipment Replacement Plan", "Quarterly Performance Review", "Marketing Campaign Analysis", "Database Backup Strategy",
  "Office Space Optimization", "Remote Work Policy", "Customer Service Guidelines", "Compliance Audit Checklist",
  "Project Timeline Review", "Vendor Contract Negotiations", "Emergency Response Plan", "Quality Assurance Process",
  "Team Building Event Planning", "Resource Allocation Review", "Technology Stack Evaluation", "Performance Metrics Dashboard",
  "Training Material Updates", "Inventory Management System", "Customer Feedback Analysis", "Process Improvement Initiative",
  "Risk Assessment Report", "Strategic Planning Session", "Document Management System", "Communication Protocol",
  "Workflow Optimization", "Data Privacy Guidelines", "Equipment Maintenance Log", "Project Status Update",
  "Meeting Room Booking System", "Employee Handbook Revision", "System Integration Plan", "Cost Analysis Report"
];

const commentTexts = [
  "This looks good to me. When do we start implementation?",
  "I have some concerns about the timeline. Can we discuss this in the next meeting?",
  "The budget allocation seems reasonable. I'll prepare the detailed breakdown.",
  "Can we add some additional safety measures to this plan?",
  "Thanks for all the feedback. I'll incorporate these suggestions into the next revision.",
  "Perfect! Looking forward to seeing the updated version.",
  "This addresses my previous concerns. Well done!",
  "The financial projections look solid now. Ready to move forward.",
  "I think we should consider alternative approaches as well.",
  "Great work on the research. The data supports our decision.",
  "We might need to adjust the timeline based on resource availability.",
  "This aligns perfectly with our strategic objectives.",
  "I suggest we run a pilot test before full implementation.",
  "The risk assessment looks comprehensive. Good job!",
  "We should involve the stakeholders in the next phase.",
  "The documentation is clear and well-structured.",
  "I have some questions about the technical requirements.",
  "This solution should improve our efficiency significantly.",
  "We need to ensure compliance with the new regulations.",
  "The cost-benefit analysis supports moving forward with this.",
  "I recommend we schedule regular check-ins during implementation.",
  "The proposed changes look promising. Let's proceed.",
  "We should consider the impact on other departments.",
  "This is exactly what we needed. Excellent work!",
  "I think we should get approval from management before proceeding."
];

// Utility functions
function randomInt(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

function randomElement(array) {
  return array[Math.floor(Math.random() * array.length)];
}

function generateRandomDate(daysAgo = 30) {
  const date = new Date();
  date.setDate(date.getDate() - randomInt(0, daysAgo));
  return date.toISOString();
}

// Generate test data
function generateTestData() {
  const data = {
    offices: [],
    users: [],
    items: [],
    comments: []
  };

  let userIdCounter = 1;
  let itemIdCounter = 1;
  let commentIdCounter = 1;

  // Generate 5 offices
  for (let officeId = 1; officeId <= 5; officeId++) {
    const office = {
      id: officeId,
      name: officeNames[officeId - 1],
      address: `${randomInt(100, 999)} ${randomElement(['Main St', 'Oak Ave', 'Pine Rd', 'Elm Dr', 'Cedar Ln'])}, ${randomElement(['Downtown', 'Westside', 'Eastside', 'Northside', 'Southside'])}`,
      settings: {
        allowPublicComments: Math.random() > 0.5,
        maxItemsPerUser: randomInt(50, 200),
        timezone: randomElement(['America/New_York', 'America/Chicago', 'America/Denver', 'America/Los_Angeles'])
      },
      adminId: userIdCounter
    };
    data.offices.push(office);

    // Generate 3-5 users per office (including 1 office admin)
    const userCount = randomInt(3, 5);
    
    // First user is office admin
    const admin = {
      id: userIdCounter++,
      username: `admin_office_${officeId}`,
      email: `admin${officeId}@company.com`,
      role: "OfficeAdmin",
      officeId: officeId,
      firstName: randomElement(firstNames),
      lastName: randomElement(lastNames),
      createdAt: generateRandomDate(60)
    };
    data.users.push(admin);

    // Generate regular users
    for (let u = 1; u < userCount; u++) {
      const user = {
        id: userIdCounter++,
        username: `user${u}_office_${officeId}`,
        email: `user${u}.office${officeId}@company.com`,
        role: "User",
        officeId: officeId,
        firstName: randomElement(firstNames),
        lastName: randomElement(lastNames),
        createdAt: generateRandomDate(60)
      };
      data.users.push(user);
    }

    // Generate 20-50 items per office
    const itemCount = randomInt(20, 50);
    const officeUsers = data.users.filter(u => u.officeId === officeId);
    
    for (let i = 1; i <= itemCount; i++) {
      const item = {
        id: itemIdCounter++,
        title: randomElement(itemTitles),
        description: `Detailed description for ${randomElement(itemTitles).toLowerCase()} in ${office.name}. This item requires attention and coordination between team members to ensure successful completion.`,
        officeId: officeId,
        createdBy: randomElement(officeUsers).id,
        createdAt: generateRandomDate(30),
        updatedAt: generateRandomDate(15)
      };
      data.items.push(item);

      // Generate 5-17 comments per item
      const commentCount = randomInt(5, 17);
      for (let c = 1; c <= commentCount; c++) {
        const comment = {
          id: commentIdCounter++,
          itemId: item.id,
          userId: randomElement(officeUsers).id,
          content: randomElement(commentTexts),
          createdAt: generateRandomDate(20)
        };
        data.comments.push(comment);
      }
    }
  }

  return data;
}

// Generate WireMock mappings with the test data
function generateWireMockMappings() {
  const testData = generateTestData();
  
  const mappings = [
    // GET /api/offices - List all offices
    {
      request: {
        method: "GET",
        url: "/api/offices"
      },
      response: {
        status: 200,
        headers: {
          "Content-Type": "application/json"
        },
        jsonBody: {
          offices: testData.offices
        }
      }
    },

    // GET /api/offices/{id} - Get specific office
    {
      request: {
        method: "GET",
        urlPattern: "/api/offices/([0-9]+)"
      },
      response: {
        status: 200,
        headers: {
          "Content-Type": "application/json"
        },
        jsonBody: {
          id: "{{request.pathSegments.[2]}}",
          name: "Office {{request.pathSegments.[2]}}",
          address: "Sample Address for Office {{request.pathSegments.[2]}}",
          settings: {
            allowPublicComments: true,
            maxItemsPerUser: 100,
            timezone: "America/New_York"
          }
        }
      }
    },

    // POST /api/offices - Create new office (Admin only)
    {
      request: {
        method: "POST",
        url: "/api/offices",
        headers: {
          "Authorization": {
            matches: "Bearer .*"
          }
        }
      },
      response: {
        status: 201,
        headers: {
          "Content-Type": "application/json"
        },
        jsonBody: {
          id: "{{randomValue length=2 type='NUMERIC'}}",
          name: "{{jsonPath request.body '$.name'}}",
          address: "{{jsonPath request.body '$.address'}}",
          settings: {
            allowPublicComments: false,
            maxItemsPerUser: 100,
            timezone: "America/New_York"
          },
          createdAt: "{{now format='yyyy-MM-dd HH:mm:ss'}}"
        }
      }
    },

    // PUT /api/offices/{id} - Update office (Admin only)
    {
      request: {
        method: "PUT",
        urlPattern: "/api/offices/([0-9]+)",
        headers: {
          "Authorization": {
            matches: "Bearer .*"
          }
        }
      },
      response: {
        status: 200,
        headers: {
          "Content-Type": "application/json"
        },
        jsonBody: {
          id: "{{request.pathSegments.[2]}}",
          name: "{{jsonPath request.body '$.name'}}",
          address: "{{jsonPath request.body '$.address'}}",
          settings: "{{jsonPath request.body '$.settings'}}",
          updatedAt: "{{now format='yyyy-MM-dd HH:mm:ss'}}"
        }
      }
    },

    // DELETE /api/offices/{id} - Delete office (Admin only)
    {
      request: {
        method: "DELETE",
        urlPattern: "/api/offices/([0-9]+)",
        headers: {
          "Authorization": {
            matches: "Bearer .*"
          }
        }
      },
      response: {
        status: 204
      }
    },

    // GET /api/users - List all users
    {
      request: {
        method: "GET",
        url: "/api/users"
      },
      response: {
        status: 200,
        headers: {
          "Content-Type": "application/json"
        },
        jsonBody: {
          users: testData.users
        }
      }
    },

    // GET /api/offices/{id}/users - Get users for specific office
    {
      request: {
        method: "GET",
        urlPattern: "/api/offices/([0-9]+)/users"
      },
      response: {
        status: 200,
        headers: {
          "Content-Type": "application/json"
        },
        jsonBody: {
          users: testData.users.filter(user => 
            user.officeId.toString() === "{{request.pathSegments.[2]}}"
          ).slice(0, 5) // Return first 5 for demo
        }
      }
    },

    // POST /api/users - Create new user (Admin or OfficeAdmin)
    {
      request: {
        method: "POST",
        url: "/api/users",
        headers: {
          "Authorization": {
            matches: "Bearer .*"
          }
        }
      },
      response: {
        status: 201,
        headers: {
          "Content-Type": "application/json"
        },
        jsonBody: {
          id: "{{randomValue length=2 type='NUMERIC'}}",
          username: "{{jsonPath request.body '$.username'}}",
          email: "{{jsonPath request.body '$.email'}}",
          role: "{{jsonPath request.body '$.role'}}",
          officeId: "{{jsonPath request.body '$.officeId'}}",
          firstName: "{{jsonPath request.body '$.firstName'}}",
          lastName: "{{jsonPath request.body '$.lastName'}}",
          createdAt: "{{now format='yyyy-MM-dd HH:mm:ss'}}"
        }
      }
    },

    // GET /api/offices/{id}/items - Get items for specific office
    {
      request: {
        method: "GET",
        urlPattern: "/api/offices/([0-9]+)/items"
      },
      response: {
        status: 200,
        headers: {
          "Content-Type": "application/json"
        },
        jsonBody: {
          items: testData.items.filter(item => 
            item.officeId.toString() === "{{request.pathSegments.[2]}}"
          ).slice(0, 10) // Return first 10 for demo
        }
      }
    },

    // GET /api/items/{id} - Get specific item
    {
      request: {
        method: "GET",
        urlPattern: "/api/items/([0-9]+)"
      },
      response: {
        status: 200,
        headers: {
          "Content-Type": "application/json"
        },
        jsonBody: {
          id: "{{request.pathSegments.[2]}}",
          title: "Sample Item {{request.pathSegments.[2]}}",
          description: "This is a sample item description for item {{request.pathSegments.[2]}}",
          officeId: 1,
          createdBy: 2,
          createdAt: "2024-12-01T09:00:00Z",
          updatedAt: "2024-12-01T09:00:00Z"
        }
      }
    },

    // POST /api/items - Create new item
    {
      request: {
        method: "POST",
        url: "/api/items",
        headers: {
          "Authorization": {
            matches: "Bearer .*"
          }
        }
      },
      response: {
        status: 201,
        headers: {
          "Content-Type": "application/json"
        },
        jsonBody: {
          id: "{{randomValue length=2 type='NUMERIC'}}",
          title: "{{jsonPath request.body '$.title'}}",
          description: "{{jsonPath request.body '$.description'}}",
          officeId: "{{jsonPath request.body '$.officeId'}}",
          createdBy: "{{jsonPath request.body '$.createdBy'}}",
          createdAt: "{{now format='yyyy-MM-dd HH:mm:ss'}}"
        }
      }
    },

    // PUT /api/items/{id} - Update item
    {
      request: {
        method: "PUT",
        urlPattern: "/api/items/([0-9]+)",
        headers: {
          "Authorization": {
            matches: "Bearer .*"
          }
        }
      },
      response: {
        status: 200,
        headers: {
          "Content-Type": "application/json"
        },
        jsonBody: {
          id: "{{request.pathSegments.[2]}}",
          title: "{{jsonPath request.body '$.title'}}",
          description: "{{jsonPath request.body '$.description'}}",
          updatedAt: "{{now format='yyyy-MM-dd HH:mm:ss'}}"
        }
      }
    },

    // DELETE /api/items/{id} - Delete item
    {
      request: {
        method: "DELETE",
        urlPattern: "/api/items/([0-9]+)",
        headers: {
          "Authorization": {
            matches: "Bearer .*"
          }
        }
      },
      response: {
        status: 204
      }
    },

    // GET /api/items/{id}/comments - Get comments for specific item
    {
      request: {
        method: "GET",
        urlPattern: "/api/items/([0-9]+)/comments"
      },
      response: {
        status: 200,
        headers: {
          "Content-Type": "application/json"
        },
        jsonBody: {
          comments: testData.comments.filter(comment => 
            comment.itemId.toString() === "{{request.pathSegments.[2]}}"
          ).slice(0, 15) // Return first 15 for demo
        }
      }
    },

    // POST /api/comments - Create new comment
    {
      request: {
        method: "POST",
        url: "/api/comments",
        headers: {
          "Authorization": {
            matches: "Bearer .*"
          }
        }
      },
      response: {
        status: 201,
        headers: {
          "Content-Type": "application/json"
        },
        jsonBody: {
          id: "{{randomValue length=2 type='NUMERIC'}}",
          itemId: "{{jsonPath request.body '$.itemId'}}",
          userId: "{{jsonPath request.body '$.userId'}}",
          content: "{{jsonPath request.body '$.content'}}",
          createdAt: "{{now format='yyyy-MM-dd HH:mm:ss'}}"
        }
      }
    },

    // PUT /api/comments/{id} - Update comment
    {
      request: {
        method: "PUT",
        urlPattern: "/api/comments/([0-9]+)",
        headers: {
          "Authorization": {
            matches: "Bearer .*"
          }
        }
      },
      response: {
        status: 200,
        headers: {
          "Content-Type": "application/json"
        },
        jsonBody: {
          id: "{{request.pathSegments.[2]}}",
          content: "{{jsonPath request.body '$.content'}}",
          updatedAt: "{{now format='yyyy-MM-dd HH:mm:ss'}}"
        }
      }
    },

    // DELETE /api/comments/{id} - Delete comment
    {
      request: {
        method: "DELETE",
        urlPattern: "/api/comments/([0-9]+)",
        headers: {
          "Authorization": {
            matches: "Bearer .*"
          }
        }
      },
      response: {
        status: 204
      }
    },

    // PATCH /api/offices/{id}/settings - Update office settings (OfficeAdmin only)
    {
      request: {
        method: "PATCH",
        urlPattern: "/api/offices/([0-9]+)/settings",
        headers: {
          "Authorization": {
            matches: "Bearer .*"
          }
        }
      },
      response: {
        status: 200,
        headers: {
          "Content-Type": "application/json"
        },
        jsonBody: {
          officeId: "{{request.pathSegments.[2]}}",
          settings: "{{jsonPath request.body '$.settings'}}",
          updatedAt: "{{now format='yyyy-MM-dd HH:mm:ss'}}"
        }
      }
    },

    // GET /api/auth/me - Get current user info
    {
      request: {
        method: "GET",
        url: "/api/auth/me",
        headers: {
          "Authorization": {
            matches: "Bearer .*"
          }
        }
      },
      response: {
        status: 200,
        headers: {
          "Content-Type": "application/json"
        },
        jsonBody: {
          id: 1,
          username: "admin1",
          email: "admin1@company.com",
          role: "Admin",
          permissions: ["create_office", "manage_users", "delete_office", "manage_all_offices"]
        }
      }
    }
  ];

  return { mappings };
}

// Generate and save the WireMock configuration
const wireMockConfig = generateWireMockMappings();

// Save to file
fs.writeFileSync('wiremock-mappings.json', JSON.stringify(wireMockConfig, null, 2));

console.log('WireMock configuration generated successfully!');
console.log('Generated test data summary:');
console.log('- 5 offices');
console.log('- 3-5 users per office (including 1 office admin)');
console.log('- 20-50 items per office');
console.log('- 5-17 comments per item');
console.log('\nTo use with WireMock:');
console.log('1. Start WireMock: java -jar wiremock-standalone.jar --port 8080');
console.log('2. Load mappings: curl -X POST http://localhost:8080/__admin/mappings/import -d @wiremock-mappings.json');
console.log('3. Test API: curl http://localhost:8080/api/offices');

// Export for use in other modules
module.exports = { generateTestData, generateWireMockMappings };