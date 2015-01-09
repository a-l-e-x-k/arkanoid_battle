namespace ServerSide
{
    public class GameRequestData
    {
        public string data = "";
        public int requestID = -1;

        public GameRequestData(int req, string dataa = "")
        {
            requestID = req;
            data = dataa;
        }
    }
}