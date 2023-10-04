package lambdas

import (
	"context"
	"encoding/json"
	"log"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/luizarnoldch/mesapara2_backend/src/users/application"
	"github.com/luizarnoldch/mesapara2_backend/src/users/domain"
)

// handleError handles an error and returns an APIGatewayProxyResponse and an error.
//
// It takes an error as a parameter and logs the error message. Then it constructs an
// APIGatewayProxyResponse with a status code of http.StatusInternalServerError and a
// body of "Internal Server Error". Finally, it returns the constructed response and
// the original error.
func handleError(err error) (events.APIGatewayProxyResponse, error) {
	log.Printf("Error: %v", err)
	return events.APIGatewayProxyResponse{StatusCode: http.StatusInternalServerError, Body: "Internal Server Error"}, err
}

// HandleRequest handles the API Gateway request and returns a response.
//
// ctx: The context.Context object for handling the request.
// request: The events.APIGatewayProxyRequest object representing the incoming request.
// returns: The events.APIGatewayProxyResponse object representing the response.
//
//	An error is returned if there was an error handling the request.
func HandleRequest(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	_, err := config.LoadDefaultConfig(ctx)
	if err != nil {
		return handleError(err)
	}

	repository := domain.NewUserRepositoryLocal()
	application := application.NewUserService(repository)

	users, err := application.FindAllUsers()
	if err != nil {
		return handleError(err)
	}

	userJSON, err := json.Marshal(users)
	if err != nil {
		return handleError(err)
	}

	response := events.APIGatewayProxyResponse{
		StatusCode: http.StatusOK,
		Body:       string(userJSON),
	}

	log.Println("SUCCESS")
	return response, nil
}

func main() {
	log.Println("Lambda Start")
	lambda.Start(HandleRequest)
	log.Println("Lambda End")
}
