const routeHome = 'home';
const pathHome = '/';

const routeMovieDetails = 'movie_details';
const pathMovieDetails = '/$routeMovieDetails/:$paramMovieTitle/:$paramMovieBudget/:$paramMovieRevenue';
const paramMovieTitle = 'title';
const paramMovieBudget = 'budget';
const paramMovieRevenue = 'revenue';

const routeMessageDialog = 'message_dialog';
const pathMessageDialog = '/$routeMessageDialog/:$paramEDialogMsgName';
const paramEDialogMsgName = 'message_type';

const routeErrorDialog = 'error_dialog';
const pathErrorDialog = '/$routeErrorDialog/:$paramError';
const paramError = 'error';
