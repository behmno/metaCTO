'use client';

import {
  Box,
  Paper,
  Typography,
  TextField,
  Button,
  Link as MUILink,
  Alert,
  CircularProgress,
} from '@mui/material';
import Layout from '@/components/Layout/Layout';
import Link from 'next/link';
import { useRegister } from '@/hooks/useAuth';
import { useState } from 'react';
import { ApiError } from '@/types/api';

export default function RegisterPage() {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const registerMutation = useRegister();

  const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    registerMutation.mutate({
      name,
      email,
      password,
    });
  };

  return (
    <Layout>
      <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: '60vh' }}>
        <Paper elevation={3} sx={{ p: 4, maxWidth: 400, width: '100%' }}>
          <Typography variant="h2" component="h1" gutterBottom align="center">
            Register
          </Typography>
          
          {registerMutation.isError && (
            <Alert severity="error" sx={{ mb: 2 }}>
              {(registerMutation.error as ApiError)?.response?.data?.detail || 'Registration failed. Please try again.'}
            </Alert>
          )}
          
          <Box component="form" onSubmit={handleSubmit} sx={{ mt: 1 }}>
            <TextField
              margin="normal"
              required
              fullWidth
              id="name"
              label="Full Name"
              name="name"
              autoComplete="name"
              autoFocus
              value={name}
              onChange={(e) => setName(e.target.value)}
              disabled={registerMutation.isPending}
            />
            <TextField
              margin="normal"
              required
              fullWidth
              id="email"
              label="Email Address"
              name="email"
              autoComplete="email"
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              disabled={registerMutation.isPending}
            />
            <TextField
              margin="normal"
              required
              fullWidth
              name="password"
              label="Password"
              type="password"
              id="password"
              autoComplete="new-password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              disabled={registerMutation.isPending}
            />
            <Button
              type="submit"
              fullWidth
              variant="contained"
              sx={{ mt: 3, mb: 2 }}
              disabled={registerMutation.isPending}
            >
              {registerMutation.isPending ? (
                <CircularProgress size={24} />
              ) : (
                'Sign Up'
              )}
            </Button>
            
            <Box sx={{ textAlign: 'center' }}>
              <MUILink component={Link} href="/login" variant="body2">
                Already have an account? Sign in
              </MUILink>
            </Box>
          </Box>
        </Paper>
      </Box>
    </Layout>
  );
}