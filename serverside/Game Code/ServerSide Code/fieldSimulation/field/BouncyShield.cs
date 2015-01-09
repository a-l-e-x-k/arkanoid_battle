namespace ServerSide
{
    public class BouncyShield
    {
        private int _currentTick;
        private bool _on;

        public bool on
        {
            get { return _on; }
        }

        public void start()
        {
            _on = true;
            _currentTick = 0;
        }

        public void update()
        {
            if (_on)
            {
                _currentTick++;
                if (_currentTick == GameConfig.BOUNCY_SHIELD_LENGTH)
                    _on = false;
            }
        }
    }
}